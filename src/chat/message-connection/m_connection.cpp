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

#include "m_connection.h"

/*!
 * \brief MConnection::MConnection
 * \param parent
 *
 * This function initializes the MConnection class.
 * Here we assign the default values for:
 *  - transferTimerId (assigned value is \c 0)
 *  - username (assigned value is "unknown")
 *  - userface (assigned value is "undefined")
 *  - state (assigned value is \c WaitingForGreeting)
 *  - isGreetingMessageSent (assigned value is \c false)
 *  - numBytesForCurrentDataType (assigned value is \c -1)
 *  - pintTimer interval (assigned value is value of \c PingInterval)
 *
 * After initializing those variables, the funnction connects the neccesary slots
 * to make everything work.
 */

MConnection::MConnection(QObject *parent) : QTcpSocket(parent) {
    transferTimerId = 0;
    username = "unknown";
    userface = "undefined";
    state = WaitingForGreeting;
    currentDataType = Undefined;
    isGreetingMessageSent = false;
    greetingMessage = "undefined";
    numBytesForCurrentDataType = -1;
    pingTimer.setInterval(PingInterval);

    connect(&pingTimer, SIGNAL(timeout()), this, SLOT(sendPing()));
    connect(this, SIGNAL(disconnected()), &pingTimer, SLOT(stop()));
    connect(this, SIGNAL(readyRead()), this, SLOT(processReadyRead()));
    connect(this, SIGNAL(connected()), this, SLOT(sendGreetingMessage()));
}

/*!
 * \brief MConnection::name
 * \return
 *
 * Returns the value of \c username.
 */

QString MConnection::name() const {
    return username;
}

/*!
 * \brief MConnection::face
 * \return
 *
 * Returns the value of \c userface
 */

QString MConnection::face() const {
    return userface;
}

/*!
 * \brief MConnection::setGreetingMessage
 * \param message
 *
 * Changes the value of \c greetingMessage to the \c message parameter.
 */

void MConnection::setGreetingMessage(const QString &message) {
    greetingMessage = message;
}

/*!
 * \brief MConnection::sendMessage
 * \param message
 *
 * Sends a byte array to the peer with the contents of \c message.
 */

void MConnection::sendMessage(const QString &message) {
    write("MESSAGE " + QByteArray::number(message.toUtf8().size()) + ' ' + message.toUtf8());
}

/*!
 * \brief MConnection::timerEvent
 * \param timerEvent
 */

void MConnection::timerEvent(QTimerEvent *timerEvent) {
    if (timerEvent->timerId() == transferTimerId) {
        abort();
        killTimer(transferTimerId);
        transferTimerId = 0;
    }
}

/*!
 * \brief MConnection::processReadyRead
 *
 * This function allows us to acknowledge the \c Greeting from our peer
 * and begin sending \c pings and \c pongs after the \c Greeting is complete
 */

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

        buffer = read(numBytesForCurrentDataType);
        if (buffer.size() != numBytesForCurrentDataType) {
            abort();
            return;
        }

        QList<QByteArray> list = buffer.split('@');

        username = QString::fromUtf8(list.at(0)) + '@' +
                peerAddress().toString();
        if (list.count() > 1)
            userface = QString(list.at(1));
        else
            userface = "/system/generic-user.png";

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
 * \brief MConnection::sendPing
 *
 * This function sends a \c ping to the peer
 * if the corresponding \c pong was received on time.
 */

void MConnection::sendPing() {
    if (pongTime.elapsed() > PongTimeout) {
        abort();
        return;
    }

    write("PING 1 p");
}

/*!
 * \brief MConnection::sendGreetingMessage
 *
 * Sends the greeting message to the peer and then verifies that the greeting
 * was sent correctly.
 */

void MConnection::sendGreetingMessage() {
    QByteArray greetingData = "GREETING "
            + QByteArray::number(greetingMessage.toUtf8().size())
            + ' '
            + greetingMessage.toUtf8();

    if (write(greetingData) == greetingData.size())
        isGreetingMessageSent = true;
}

/*!
 * \brief MConnection::readDataIntoBuffer
 * \return
 *
 * Adds the data of a new packet to the current buffer.
 */

int MConnection::readDataIntoBuffer() {
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
 * \brief MConnection::dataLengthForCurrentDataType
 * \return
 */

int MConnection::dataLengthForCurrentDataType() {
    if (bytesAvailable() <= 0 || readDataIntoBuffer() <= 0 ||
            !buffer.endsWith(SeparatorToken))
        return 0;

    buffer.chop(1);
    int number = buffer.toInt();
    buffer.clear();
    return number;
}

/*!
 * \brief MConnection::hasEnoughData
 * \return
 */

bool MConnection::hasEnoughData() {
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
 * \brief MConnection::readProtocolHeader
 * \return
 *
 * Determines the kind of data that we received. Possible values are:
 *  - Ping
 *  - Pong
 *  - Greeting
 *  - Message
 *
 * If the function detects another kind of file, it assings the \c Undefined flag
 * to the receied data.
 */

bool MConnection::readProtocolHeader() {
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

/*!
 * \brief MConnection::processData
 *
 * Based on the data, the function does a different action:
 *  - If data is a \c Ping, we write a \c Pong
 *  - If data is a \c Pong, we send a \c Ping
 *  - If data is a \c PlainText, we notify the \c Client that we received a message
 */

void MConnection::processData() {
    buffer = read(numBytesForCurrentDataType);

    if (buffer.size() != numBytesForCurrentDataType) {
        abort();
        return;
    }

    switch (currentDataType) {
    case PlainText:
        emit newMessage(username, userface, QString::fromUtf8(buffer));
        break;
    case Ping:
        write("PONG 1 p");
        break;
    case Pong:
        pongTime.restart();
        break;
    default:
        break;
    }

    currentDataType = Undefined;
    numBytesForCurrentDataType = 0;
    buffer.clear();
}
