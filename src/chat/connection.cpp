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

#include "connection.h"

static const int TransferTimeout = 120 * 1000;
static const int PongTimeout = 60 * 1000;
static const int PingInterval = 5 * 1000;
static const char SeparatorToken = ' ';

Connection::Connection(QObject *parent) : QTcpSocket(parent) {
    transferTimerId = 0;
    username = "unknown";
    userface = "undefined";
    state = WaitingForGreeting;
    currentDataType = Undefined;
    isGreetingMessageSent = false;
    greetingMessage = "undefined";
    numBytesForCurrentDataType = -1;
    pingTimer.setInterval(PingInterval);

    QObject::connect(this, SIGNAL(readyRead()), this, SLOT(processReadyRead()));
    QObject::connect(this, SIGNAL(disconnected()), &pingTimer, SLOT(stop()));
    QObject::connect(&pingTimer, SIGNAL(timeout()), this, SLOT(sendPing()));
    QObject::connect(this, SIGNAL(connected()), this,
                     SLOT(sendGreetingMessage()));
}

QString Connection::name() const {
    return username;
}

QString Connection::face() const {
    return userface;
}

void Connection::setGreetingMessage(const QString &message) {
    greetingMessage = message;
}

bool Connection::sendMessage(const QString &message) {
    QByteArray data = "MESSAGE " + QByteArray::number(message.toUtf8().size())
            + ' ' + message.toUtf8();
    return write(data) == data.size();
}

bool Connection::sendFile(const QString &fileName) {
    QFile file(fileName);
    file.open(QFile::ReadOnly);
    QByteArray data = file.readAll();
    file.close();

    QByteArray msg = "BINARY " + QByteArray::number(data.size()) + ' ' + data;

    QByteArray fileBA = QFileInfo(file).fileName().toUtf8();
    QByteArray fileData = "FILENAME " + QByteArray::number(fileBA.size())
            + ' ' + fileBA;

    return (write(fileData) == fileData.size() && write(msg) == msg.size());
}

void Connection::timerEvent(QTimerEvent *timerEvent) {
    if (timerEvent->timerId() == transferTimerId) {
        abort();
        killTimer(transferTimerId);
        transferTimerId = 0;
    }
}

void Connection::processReadyRead() {
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

void Connection::sendPing() {
    if (pongTime.elapsed() > PongTimeout) {
        abort();
        return;
    }

    write("PING 1 p");
}

void Connection::sendGreetingMessage() {
    QByteArray greetingData = "GREETING "
            + QByteArray::number(greetingMessage.toUtf8().size())
            + ' '
            + greetingMessage.toUtf8();

    if (write(greetingData) == greetingData.size())
        isGreetingMessageSent = true;
}

int Connection::readDataIntoBuffer(int maxSize) {
    if (maxSize > MaxBufferSize)
        return 0;

    int numBytesBeforeRead = buffer.size();
    if (numBytesBeforeRead == MaxBufferSize) {
        abort();
        return 0;
    }

    while (bytesAvailable() > 0 && buffer.size() < maxSize) {
        buffer.append(read(1));
        if (buffer.endsWith(SeparatorToken))
            break;
    }

    return buffer.size() - numBytesBeforeRead;
}

int Connection::dataLengthForCurrentDataType() {
    if (bytesAvailable() <= 0 || readDataIntoBuffer() <= 0 ||
            !buffer.endsWith(SeparatorToken))
        return 0;

    buffer.chop(1);
    int number = buffer.toInt();
    buffer.clear();
    return number;
}

bool Connection::hasEnoughData() {
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

bool Connection::readProtocolHeader() {
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
    else if (buffer == "FACE ")
        currentDataType = Face;
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

void Connection::processData() {
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