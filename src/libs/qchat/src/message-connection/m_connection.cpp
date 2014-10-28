//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  This file is released under the terms of the BSD license.
//

#include "m_connection.h"

MConnection::MConnection (QObject *parent) : QTcpSocket (parent) {
    transferTimerId = 0;
    m_nickname = "unknown";
    state = WaitingForGreeting;
    currentDataType = Undefined;
    isGreetingMessageSent = false;
    greetingMessage = "undefined";
    numBytesForCurrentDataType = -1;
    pingTimer.setInterval (PING_INTERVAL);
    connect (&pingTimer, SIGNAL (timeout()), this, SLOT (sendPing()));
    connect (this, SIGNAL (disconnected()), &pingTimer, SLOT (stop()));
    connect (this, SIGNAL (readyRead()), this, SLOT (processReadyRead()));
    connect (this, SIGNAL (connected()), this, SLOT (sendGreetingMessage()));
}

QString MConnection::id() const {
    return nickname() + "@" + peerAddress().toString();
}

QString MConnection::nickname() const {
    return m_nickname;
}

QImage MConnection::profilePicture() const {
    return profile_picture;
}

void MConnection::setGreetingMessage (const QByteArray& message) {
    greetingMessage = message;
}

void MConnection::sendStatus (const QString &status) {
    write ("STATUS " + QByteArray::number (status.toUtf8().size()) + ' ' +
           status.toUtf8());
}

void MConnection::sendMessage (const QString& message) {
    write ("MESSAGE " + QByteArray::number (message.toUtf8().size()) + ' ' +
           message.toUtf8());
}

void MConnection::timerEvent (QTimerEvent *timerEvent) {
    if (timerEvent->timerId() == transferTimerId) {
        abort();
        killTimer (transferTimerId);
        transferTimerId = 0;
    }
}

void MConnection::processReadyRead() {
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

        QList<QByteArray> list = buffer.split ('@');
        m_nickname = QString::fromUtf8 (list.at (0));

        if (m_nickname.isEmpty())
            m_nickname = tr ("Unknown");

        if (list.count() > 1) {
            QByteArray image;

            for (int i = 1; list.count() > i; i++)
                image.append (list.at (i) + '@');

            profile_picture.loadFromData (image);
        }

        else
            profile_picture = QImage (":/faces/faces/generic-user.png");

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

void MConnection::sendPing() {
    if (pongTime.elapsed() > PONG_TIMEOUT) {
        abort();
        return;
    }

    write ("PING 1 p");
}

void MConnection::sendGreetingMessage() {
    QByteArray greetingData = "GREETING " +
                              QByteArray::number (greetingMessage.size()) + ' ' +
                              greetingMessage;

    if (write (greetingData) == greetingData.size())
        isGreetingMessageSent = true;
}

int MConnection::readDataIntoBuffer() {
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

int MConnection::dataLengthForCurrentDataType() {
    if (bytesAvailable() <= 0 || readDataIntoBuffer() <= 0 ||
            !buffer.endsWith (SEPARATOR_TOKEN))
        return 0;

    buffer.chop (1);
    int number = buffer.toInt();
    buffer.clear();
    return number;
}

bool MConnection::hasEnoughData() {
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

bool MConnection::readProtocolHeader() {
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

    else if (buffer == "STATUS ")
        currentDataType = Status;

    else if (buffer == "MESSAGE ")
        currentDataType = PlainText;

    else if (buffer == "GREETING ")
        currentDataType = Greeting;

    else {
        currentDataType = Undefined;
        abort();
        return false;
    }

    buffer.clear();
    numBytesForCurrentDataType = dataLengthForCurrentDataType();
    return true;
}

void MConnection::processData() {
    buffer = read (numBytesForCurrentDataType);

    if (buffer.size() != numBytesForCurrentDataType) {
        abort();
        return;
    }

    switch (currentDataType) {
        case PlainText:
            emit newMessage (m_nickname, QString::fromUtf8 (buffer));
            break;

        case Ping:
            write ("PONG 1 p");
            break;

        case Pong:
            pongTime.restart();
            break;

        case Status:
            emit statusChanged (id(), QString::fromUtf8 (buffer));
            break;

        default:
            break;
    }

    currentDataType = Undefined;
    numBytesForCurrentDataType = 0;
    buffer.clear();
}
