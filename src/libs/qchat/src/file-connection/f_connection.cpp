//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  This file is released under the terms of the BSD license.
//

#include "f_connection.h"

FConnection::FConnection (QObject *parent) : QTcpSocket (parent) {
    transferTimerId = 0;
    downloadedBytes = 0;
    currentDownloadSize = 0;
    downloadStarted = false;
    state = WaitingForGreeting;
    currentDataType = Undefined;
    isGreetingMessageSent = false;
    numBytesForCurrentDataType = -1;
    pingTimer.setInterval (PING_INTERVAL);

    connect (&pingTimer, SIGNAL (timeout()), this, SLOT (sendPing()));
    connect (this, SIGNAL (disconnected()), &pingTimer, SLOT (stop()));
    connect (this, SIGNAL (readyRead()), this, SLOT (processReadyRead()));
    connect (this, SIGNAL (connected()), this, SLOT (sendGreetingMessage()));
    connect (&downloadTimer, SIGNAL (timeout()), this, SLOT (calculateDownloadProgress()));
    connect (this, SIGNAL (downloadComplete (QString, QString)), &downloadTimer, SLOT (stop()));
}

void FConnection::setDownloadPath (const QString& path) {
    m_download_dir = path;
}

void FConnection::sendFile (const QString& path) {
    QFile file (path);
    file.open (QFile::ReadOnly);

    QByteArray data = qCompress (file.readAll(), 9);
    QByteArray fileContents = "BINARY " + QByteArray::number (data.size()) + ' ' + data;
    QByteArray f_data = QFileInfo (file).fileName().toUtf8() + '@' + QByteArray::number (data.size());
    QByteArray fileData =  "FILEDATA " + QByteArray::number (f_data.size()) + ' ' + f_data;

    file.close();
    data.clear();

    if (write (fileData) == fileData.size())
        if (write (fileContents) == fileContents.size())
            qDebug() << "File transfer complete!";
}

void FConnection::timerEvent (QTimerEvent *timerEvent) {
    if (timerEvent->timerId() == transferTimerId) {
        abort();
        killTimer (transferTimerId);
        transferTimerId = 0;
    }
}

void FConnection::processReadyRead() {
    if (state == WaitingForGreeting) {
        if (!readProtocolHeader())
            return;

        if (currentDataType != Greeting) {
            abort();
            return;
        }

        state = ReadingGreeting;
    }

    if (state == ReadingGreeting) {
        if (!hasEnoughData())
            return;

        buffer = read (numBytesForCurrentDataType);

        if (buffer.size() != numBytesForCurrentDataType) {
            abort();
            return;
        }

        m_nickname = QString::fromUtf8 (buffer);
        currentDataType = Undefined;
        numBytesForCurrentDataType = 0;
        buffer.clear();

        if (!isValid()) {
            abort();
            return;
        }

        if (!isGreetingMessageSent)
            sendGreetingMessage();

        pingTimer.start();
        pongTime.start();
        state = ReadyForUse;
        emit readyForUse();
    }

    while (bytesAvailable() > 0) {
        if (currentDataType == Undefined)
            if (!readProtocolHeader())
                return;

        if (!hasEnoughData())
            return;

        processData();
    }
}

void FConnection::sendPing() {
    if (pongTime.elapsed() > PONG_TIMEOUT) {
        abort();
        return;
    }

    write ("PING 1 p");
}

void FConnection::sendGreetingMessage() {
    QString _greeting_message = QSettings ("WinT 3794", "WinT Messenger")
                                .value ("nickname", "unknown")
                                .toString();
    QByteArray _greeting_data =
        "GREETING " + QByteArray::number (_greeting_message.toUtf8().size()) +
        ' ' + _greeting_message.toUtf8();

    if (write (_greeting_data) == _greeting_data.size())
        isGreetingMessageSent = true;
}

int FConnection::readDataIntoBuffer() {
    int numBytesBeforeRead = buffer.size();

    if (numBytesBeforeRead == MAX_BUFFER_SIZE) {
        abort();
        return 0;
    }

    while (bytesAvailable() > 0 && buffer.size() < MAX_BUFFER_SIZE) {
        buffer.append (read (1));

        if (buffer.endsWith (SEPARATOR_TOKEN))
            break;
    }

    return buffer.size() - numBytesBeforeRead;
}

int FConnection::dataLengthForCurrentDataType() {
    if (bytesAvailable() <= 0 || readDataIntoBuffer() <= 0 ||
            !buffer.endsWith (SEPARATOR_TOKEN))
        return 0;

    buffer.chop (1);
    int number = buffer.toInt();
    buffer.clear();
    return number;
}

bool FConnection::hasEnoughData() {
    if (transferTimerId) {
        QObject::killTimer (transferTimerId);
        transferTimerId = 0;
    }

    if (numBytesForCurrentDataType <= 0)
        numBytesForCurrentDataType = dataLengthForCurrentDataType();

    if (bytesAvailable() < numBytesForCurrentDataType ||
            numBytesForCurrentDataType <= 0) {
        transferTimerId = startTimer (TRANSFER_TIMEOUT);
        return false;
    }

    return true;
}

bool FConnection::readProtocolHeader() {
    if (transferTimerId) {
        killTimer (transferTimerId);
        transferTimerId = 0;
    }

    if (readDataIntoBuffer() <= 0) {
        transferTimerId = startTimer (TRANSFER_TIMEOUT);
        return false;
    }

    if (buffer == "PING ")
        currentDataType = Ping;

    else if (buffer == "PONG ")
        currentDataType = Pong;

    else if (buffer == "GREETING ")
        currentDataType = Greeting;

    else if (buffer == "FILEDATA ")
        currentDataType = FileData;

    else if (buffer == "BINARY ") {
        currentDataType = Binary;

        if (!downloadStarted) {
            downloadStarted = true;
            downloadTimer.start (100);
            emit newDownload (m_nickname, currentFileName, currentDownloadSize);
        }
    }

    else {
        currentDataType = Undefined;
        abort();
        return false;
    }

    buffer.clear();
    numBytesForCurrentDataType = dataLengthForCurrentDataType();
    return true;
}

void FConnection::processData() {
    buffer = read (numBytesForCurrentDataType);

    if (buffer.size() != numBytesForCurrentDataType) {
        abort();
        return;
    }

    switch (currentDataType) {
        case Ping: {
                write ("PONG 1 p");
                break;
            }

        case Pong: {
                pongTime.restart();
                break;
            }

        case FileData: {
                QList<QByteArray> list = buffer.split ('@');
                currentFileName = QString::fromUtf8 (list.at (0));

                if (list.count() > 1)
                    currentDownloadSize = QString::fromUtf8 (list.at (1)).toInt();

                else
                    currentDownloadSize = 0;

                break;
            }

        case Binary: {
                downloadedBytes = 0;
                downloadStarted = false;
                QByteArray uncompressedData = qUncompress (buffer);
                QFile file (m_download_dir + currentFileName);

                if (file.open (QFile::WriteOnly))
                    file.write (uncompressedData);

                file.close();
                uncompressedData.clear();
                emit downloadComplete (m_nickname, currentFileName);
                break;
            }

        default: {
                break;
            }
    }

    currentDataType = Undefined;
    numBytesForCurrentDataType = 0;
    buffer.clear();
}

void FConnection::calculateDownloadProgress() {
    if (downloadStarted) {
        downloadedBytes = bytesAvailable();

        if (downloadedBytes > 0) {
            if (currentDownloadSize > 0)
                emit updateProgress (
                    m_nickname,
                    currentFileName,
                    (int) ((downloadedBytes / currentDownloadSize) * 100));

            else
                emit updateProgress (m_nickname, currentFileName, 0);
        }
    }
}
