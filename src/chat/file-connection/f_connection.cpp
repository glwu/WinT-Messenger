/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
** Redistributions of source code must retain the above copyright
** notice, this list of conditions and the following disclaimer.
** Redistributions in binary form must reproduce the above copyright
** notice, this list of conditions and the following disclaimer in
** the documentation and/or other materials provided with the
** distribution.
** Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
** of its contributors may be used to endorse or promote products derived
** from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "f_connection.h"

/*!
 * \brief FConnection::FConnection
 * \param parent
 *
 * This function initializes the FConnection class.
 * Here we assign the default values for:
 *  - transferTimerId (assigned value is \c 0)
 *  - state (assigned value is \c WaitingForGreeting)
 *  - isGreetingMessageSent (assigned value is \c false)
 *  - numBytesForCurrentDataType (assigned value is \c -1)
 *  - pintTimer interval (assigned value is value of \c PingInterval)
 *
 * After initializing those variables, the funnction connects the neccesary slots
 * to make everything work.
 */

FConnection::FConnection(QObject *parent) : QTcpSocket(parent) {
    transferTimerId = 0;
    state = WaitingForGreeting;
    currentDataType = Undefined;
    isGreetingMessageSent = false;
    numBytesForCurrentDataType = -1;
    pingTimer.setInterval(PingInterval);

    QObject::connect(this, SIGNAL(readyRead()), this, SLOT(processReadyRead()));
    QObject::connect(this, SIGNAL(disconnected()), &pingTimer, SLOT(stop()));
    QObject::connect(&pingTimer, SIGNAL(timeout()), this, SLOT(sendPing()));
    QObject::connect(this, SIGNAL(connected()), this, SLOT(sendGreetingMessage()));
}

/*!
 * \brief FConnection::sendFile
 * \param path
 *
 * This funcition reads, compresses and sends a file to the peer.
 */

void FConnection::sendFile(const QString &path) {
    QFile file(path);
    file.open(QFile::ReadOnly);

    QByteArray data = qCompress(file.readAll(), 9);
    QByteArray fileContents = "BINARY " + QByteArray::number(data.size()) + ' ' + data;
    QByteArray fileName = "FILENAME " + QByteArray::number(QFileInfo(file).fileName().toUtf8().size())
            + ' ' + QFileInfo(file).fileName().toUtf8();

    file.close();
    data.clear();

    write(fileName);
    write(fileContents);
}

/*!
 * \brief FConnection::timerEvent
 * \param timerEvent
 */

void FConnection::timerEvent(QTimerEvent *timerEvent) {
    if (timerEvent->timerId() == transferTimerId) {
        abort();
        killTimer(transferTimerId);
        transferTimerId = 0;
    }
}

/*!
 * \brief FConnection::processReadyRead
 *
 * This function allows us to acknowledge the \c Greeting from our peer
 * and begin sending /c pings and /c pongs after the \c Greeting is complete
 */

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

        buffer = read(numBytesForCurrentDataType);
        if (buffer.size() != numBytesForCurrentDataType) {
            abort();
            return;
        }

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

/*!
 * \brief FConnection::sendPing
 *
 * This function sends a \c ping to the peer
 * if the corresponding \c pong was received on time.
 */

void FConnection::sendPing() {
    if (pongTime.elapsed() > PongTimeout) {
        abort();
        return;
    }

    write("PING 1 p");
}

/*!
 * \brief FConnection::sendGreetingMessage
 *
 * Sends the greeting message to the peer and then verifies that the greeting
 * was sent correctly.
 */

void FConnection::sendGreetingMessage() {
    QString greetingMessage = "Greetings";
    QByteArray greetingData = "GREETING "
            + QByteArray::number(greetingMessage.toUtf8().size())
            + ' '
            + greetingMessage.toUtf8();

    if (write(greetingData) == greetingData.size())
        isGreetingMessageSent = true;
}

/*!
 * \brief FConnection::readDataIntoBuffer
 * \return
 *
 * Adds the data of a new packet to the current buffer.
 */

int FConnection::readDataIntoBuffer() {
    int numBytesBeforeRead = buffer.size();
    if (numBytesBeforeRead == MaxBufferSize) {
        abort();
        return 0;
    }

    while (bytesAvailable() > 0 && buffer.size() < MaxBufferSize) {
        buffer.append(read(1));
        if (buffer.endsWith(SeparatorToken))
            break;
    }

    return buffer.size() - numBytesBeforeRead;
}

/*!
 * \brief FConnection::dataLengthForCurrentDataType
 * \return
 */

int FConnection::dataLengthForCurrentDataType() {
    if (bytesAvailable() <= 0 || readDataIntoBuffer() <= 0 ||
            !buffer.endsWith(SeparatorToken))
        return 0;

    buffer.chop(1);
    int number = buffer.toInt();
    buffer.clear();
    return number;
}

/*!
 * \brief FConnection::hasEnoughData
 * \return
 */

bool FConnection::hasEnoughData() {
    if (transferTimerId) {
        QObject::killTimer(transferTimerId);
        transferTimerId = 0;
    }

    if (numBytesForCurrentDataType <= 0)
        numBytesForCurrentDataType = dataLengthForCurrentDataType();

    if (bytesAvailable() < numBytesForCurrentDataType ||
            numBytesForCurrentDataType <= 0) {
        transferTimerId = startTimer(TransferTimeout);
        return false;
    }

    return true;
}

/*!
 * \brief FConnection::readProtocolHeader
 * \return
 *
 * Determines the kind of data that we received. Possible values are:
 *  - Ping
 *  - Pong
 *  - Greeting
 *  - Binary
 *  - Filename
 *
 * If the function detects another kind of file, it assings the /c Undefined flag
 * to the receied data.
 */

bool FConnection::readProtocolHeader() {
    if (transferTimerId) {
        killTimer(transferTimerId);
        transferTimerId = 0;
    }

    if (readDataIntoBuffer() <= 0) {
        transferTimerId = startTimer(TransferTimeout);
        return false;
    }

    if (buffer == "PING ")
        currentDataType = Ping;
    else if (buffer == "PONG ")
        currentDataType = Pong;
    else if (buffer == "GREETING ")
        currentDataType = Greeting;
    else if (buffer == "BINARY ")
        currentDataType = Binary;
    else if (buffer == "FILENAME ")
        currentDataType = FileName;
    else {
        currentDataType = Undefined;
        abort();
        return false;
    }

    buffer.clear();
    numBytesForCurrentDataType = dataLengthForCurrentDataType();
    return true;
}

/*!
 * \brief FConnection::processData
 *
 * Based on the data, the function does a different action:
 *  - If data is a \c Ping, we write a \c Pong
 *  - If data is a \c Pong, we send a \c Ping
 *  - If data is a \c FileName, we change the value of /c currentFileName
 *  - If data is a \c Binary, we notify the \c Client that we received a new file.
 */

void FConnection::processData() {
    buffer = read(numBytesForCurrentDataType);

    if (buffer.size() != numBytesForCurrentDataType) {
        abort();
        return;
    }

    switch (currentDataType) {
    case Ping:
        write("PONG 1 p");
        break;
    case Pong:
        pongTime.restart();
        break;
    case FileName:
        currentFileName = QString::fromUtf8(buffer);
        break;
    case Binary:
        emit newFile(buffer, currentFileName);
        break;
    default:
        break;
    }

    currentDataType = Undefined;
    numBytesForCurrentDataType = 0;
    buffer.clear();
}
