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
    // Prepare the variables for use
    transferTimerId = 0;
    downloadedBytes = 0;
    currentDownloadSize = 0;
    downloadStarted = false;
    state = WaitingForGreeting;
    currentDataType = Undefined;
    isGreetingMessageSent = false;
    numBytesForCurrentDataType = -1;
    pingTimer.setInterval(PingInterval);

    // Connect signals/slots
    connect(&pingTimer, SIGNAL(timeout()), this, SLOT(sendPing()));
    connect(this, SIGNAL(disconnected()), &pingTimer, SLOT(stop()));
    connect(this, SIGNAL(readyRead()), this, SLOT(processReadyRead()));
    connect(this, SIGNAL(connected()), this, SLOT(sendGreetingMessage()));
    connect(this, SIGNAL(bytesWritten(qint64)), this, SLOT(calculateDownloadProgress(qint64)));
}

/*!
 * \brief FConnection::sendFile
 * \param path
 *
 * This funcition reads, compresses and sends a file to the peer.
 */

void FConnection::sendFile(const QString &path) {
    // Open the file
    QFile file(path);
    file.open(QFile::ReadOnly);

    // Read the file and compress it
    QByteArray data = qCompress(file.readAll(), 9);

    // Create the datagrams to send
    QByteArray f_data = QFileInfo(file).fileName().toUtf8() + '@' + QByteArray::number(data.size());

    QByteArray fileContents = "BINARY " + QByteArray::number(data.size()) + ' ' + data;
    QByteArray fileData = "FILEDATA " + QByteArray::number(f_data.size()) + ' ' + f_data;

    // Close the file and clear the compressed data to save memory
    file.close();
    data.clear();

    // Send the datagrams
    if (write(fileData) == fileData.size())
        if (write(fileContents) == fileContents.size())
            qDebug() << "File transfer complete!";
}

/*!
 * \brief FConnection::timerEvent
 * \param timerEvent
 */

void FConnection::timerEvent(QTimerEvent *timerEvent) {
    // Abort the current transfer if it does not respond
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
 * and begin sending \c pings and \c pongs after the \c Greeting is complete
 */

void FConnection::processReadyRead() {
    // Prepare the hand shake between the computer and the peer
    if (state == WaitingForGreeting) {
        // Verify that the header is valid
        if (!readProtocolHeader())
            return;

        // Deny any incoming connection that IS NOT a greeting
        if (currentDataType != Greeting) {
            abort();
            return;
        }

        // Change the current state of the connection
        state = ReadingGreeting;
    }

    // Read the greeting message
    if (state == ReadingGreeting) {
        if (!hasEnoughData())
            return;

        // Read the buffer and verify it
        buffer = read(numBytesForCurrentDataType);
        if (buffer.size() != numBytesForCurrentDataType) {
            abort();
            return;
        }

        // Setup the variables for the next data exchange
        currentDataType = Undefined;
        numBytesForCurrentDataType = 0;
        buffer.clear();

        // Verify that the greeting is valid
        if (!isValid()) {
            abort();
            return;
        }

        // Respond to the greeting to complete the handshake
        if (!isGreetingMessageSent)
            sendGreetingMessage();

        // Start the PING and the PONG processes
        pingTimer.start();
        pongTime.start();

        // Change the current state of the connection
        state = ReadyForUse;

        // Tell the rest of the class that the connection is ready for use
        emit readyForUse();
    }

    // Begin the send/receive process
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
    // If the peer does not respond abort the connection
    if (pongTime.elapsed() > PongTimeout) {
        abort();
        return;
    }

    // Send a ping
    write("PING 1 p");
}

/*!
 * \brief FConnection::sendGreetingMessage
 *
 * Sends the greeting message to the peer and then verifies that the greeting
 * was sent correctly.
 */

void FConnection::sendGreetingMessage() {
    // Prepare the greeting datagram
    QString greetingMessage = "Hello peer!";
    QByteArray greetingData = "GREETING "
            + QByteArray::number(greetingMessage.toUtf8().size())
            + ' '
            + greetingMessage.toUtf8();

    // Send the datagram and verify that it was received correctly
    if (write(greetingData) == greetingData.size())
        isGreetingMessageSent = true;
}

/*!
 * \brief FConnection::readDataIntoBuffer
 * \return
 *
 * Returns the size of the downloaded datagram
 */

int FConnection::readDataIntoBuffer() {
    // Record the number of bytes before reading data into the buffer
    int numBytesBeforeRead = buffer.size();

    // Avoid something roughly similar to the ping of death
    if (numBytesBeforeRead == MaxBufferSize) {
        abort();
        return 0;
    }

    // Read data into the buffer
    while (bytesAvailable() > 0 && buffer.size() < MaxBufferSize) {
        buffer.append(read(1));
        if (buffer.endsWith(SeparatorToken))
            break;
    }

    // Return the number of bytes that where read
    return buffer.size() - numBytesBeforeRead;
}

/*!
 * \brief FConnection::dataLengthForCurrentDataType
 * \return
 *
 * Converts the downloaded datagram into a base 10 number
 */

int FConnection::dataLengthForCurrentDataType() {
    // Verify that the datagram received was valid
    if (bytesAvailable() <= 0 || readDataIntoBuffer() <= 0 || !buffer.endsWith(SeparatorToken))
        return 0;

    // Remove 1 bytes from the end of the byte array
    buffer.chop(1);

    // Convert the buffer to base 10
    int number = buffer.toInt();

    // Clear the current buffer
    buffer.clear();

    // Return the converted buffer
    return number;
}

/*!
 * \brief FConnection::hasEnoughData
 * \return
 *
 * Return \c true if we can proceed with the transfer process.
 */

bool FConnection::hasEnoughData() {
    if (transferTimerId) {
        QObject::killTimer(transferTimerId);
        transferTimerId = 0;
    }

    // Calculate the number of bytes for the current datagram
    if (numBytesForCurrentDataType <= 0)
        numBytesForCurrentDataType = dataLengthForCurrentDataType();

    // Return false if we cannot complete the transfer process
    if (bytesAvailable() < numBytesForCurrentDataType || numBytesForCurrentDataType <= 0) {
        transferTimerId = startTimer(TransferTimeout);
        return false;
    }

    // Return true so that we can proceed with the transfer process
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
 * If the function detects another kind of file, it assings the \c Undefined flag
 * to the receied data.
 */

bool FConnection::readProtocolHeader() {
    if (transferTimerId) {
        killTimer(transferTimerId);
        transferTimerId = 0;
    }

    // Ensure that the current datagram is bigger than 0
    if (readDataIntoBuffer() <= 0) {
        transferTimerId = startTimer(TransferTimeout);
        return false;
    }

    // The current datagram is a PING
    if (buffer == "PING ")
        currentDataType = Ping;

    // The current datagram is a PONG
    else if (buffer == "PONG ")
        currentDataType = Pong;

    // The current datagram is a GREETING, this datagram is only used once
    // during the initial handshake between a peer and another peer.
    else if (buffer == "GREETING ")
        currentDataType = Greeting;

    // The current datagram is a BINARY (any shared file)
    else if (buffer == "BINARY ") {
        currentDataType = Binary;

        // Because WinT Messenger sends first information about the shared file
        // and then the contents of the shared file, we can safely asume that
        // the program already knows the basic information of the file (such as)
        // the file name and file size. Taking into account that, we can safely
        // send the needed file information to the QML interface so that the user
        // can know that a file is being downloaded.
        if (!downloadStarted) {
            downloadStarted = true;
            emit newDownload(peerAddress().toString(), currentFileName, currentDownloadSize);
        }
    }

    // The current datagram is a FILEDATA (the data of any shared file). This
    // data type contains the filename and the size of the file in question.
    // Note that this kind of data is ALWAYS sent before the transfer of the
    // contents of the file begins.
    else if (buffer == "FILEDATA ")
        currentDataType = FileData;

    // The current datagram is unknown, so we ignore it
    else {
        currentDataType = Undefined;
        abort();
        return false;
    }

    // Clear the buffer and calculate the length of the datagram
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
 *  - If data is a \c FileName, we change the value of \c currentFileName
 *  - If data is a \c Binary, we notify the \c Client that we received a new file.
 */

void FConnection::processData() {
    // Read the current contents of the datagram
    buffer = read(numBytesForCurrentDataType);

    // Ensure that the buffer is valid
    if (buffer.size() != numBytesForCurrentDataType) {
        abort();
        return;
    }

    // Do a different action based on the current data type
    switch (currentDataType) {

    // Respond to the PING request with a PONG
    case Ping: {
        write("PONG 1 p");
        break;
    }

        // Reset the ping process
    case Pong: {
        pongTime.restart();
        break;
    }

        // Split the incoming information to obtain the file name and the file
        // size.
    case FileData: {
        QList<QByteArray> list = buffer.split('@');
        currentFileName = QString::fromUtf8(list.at(0));

        // Avoid crashing the app when talking to other clients
        if (list.count() > 1)
            currentDownloadSize = QString::fromUtf8(list.at(1)).toInt();
        else
            currentDownloadSize = 0;

        break;
    }

        // Tell the QML interface that the download has completed and prepare the
        // variables for the next download
    case Binary: {
        downloadedBytes = 0;
        downloadStarted = false;
        emit newFile(buffer, currentFileName);
        emit downloadComplete(peerAddress().toString(), currentFileName);
        break;
    }

        // Do nothing
    default: {
        break;
    }
    }

    // Clear the current data type and the buffer
    currentDataType = Undefined;
    numBytesForCurrentDataType = 0;
    buffer.clear();
}

/*!
 * \brief FConnection::calculateDownloadProgress
 * \param recievedBytes
 *
 * Returns the progress of the download with numbers ranging from 0 to 100.
 */

void FConnection::calculateDownloadProgress(qint64 recievedBytes) {
    // Only calculate the download progress if the file is 'binary'
    if (downloadStarted) {
        // Append the received bytes to the downloaded bytes
        downloadedBytes += (int)recievedBytes;

        // If the downloaded bytes are greater than zero, calculate the progress
        // of the download
        if (downloadedBytes > 0) {
            if (currentDownloadSize > 0)
                emit updateProgress(peerAddress().toString(), currentFileName, (downloadedBytes / currentDownloadSize) * 100);
            else
                emit updateProgress(peerAddress().toString(), currentFileName, 0);
        }
    }
}
