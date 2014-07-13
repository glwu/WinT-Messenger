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

#include "client.h"

/*!
 * \brief Client::Client
 *
 * Initializes the \c Client, configures the \c PeerManager and
 * connects functions between the \c PeerManager, the \c MServer,
 * the \c FServer and the \c Client.
 */

Client::Client() {
    peerManager = new PeerManager(this);
    peerManager->setFileServerPort(f_server.serverPort());
    peerManager->setMessageServerPort(m_server.serverPort());
    peerManager->startBroadcasting();

    QObject::connect(peerManager, SIGNAL(newMessageConnection(MConnection*)), this, SLOT(newMessageConnection(MConnection*)));
    QObject::connect(peerManager, SIGNAL(newFileConnection(FConnection*)), this, SLOT(newFileConnection(FConnection*)));
    QObject::connect(&m_server, SIGNAL(newConnection(MConnection*)), this, SLOT(newMessageConnection(MConnection*)));
    QObject::connect(&f_server, SIGNAL(newConnection(FConnection*)), this, SLOT(newFileConnection(FConnection*)));
}

/*!
 * \brief Client::sendMessage
 * \param message
 *
 * Sends a a message to all connected peers by using a list
 * of \c MConnections.
 */

void Client::sendMessage(const QString &message) {
    if (!message.isEmpty()) {
        QList<MConnection *> connections = message_peers.values();
        foreach (MConnection *connection, connections)
            connection->sendMessage(message);
    }
}

/*!
 * \brief Client::sendFile
 * \param path
 *
 * Sends the path of the file to be shared to all connected peers
 * by using a list of \c FConnections.
 *
 * Then, we send a message to all connected peers (with the \c sendMessage(QString) function)
 * that notifies the connected peers that we shared a file.
 */

void Client::sendFile(const QString &path) {
    if (!path.isEmpty()) {
        QList<FConnection *> file_connections = file_peers.values();
        foreach (FConnection *connection, file_connections)
            connection->sendFile(path);

        QFile file(path);
        sendMessage(QString("Shared %1").arg(QFileInfo(file).fileName()));
    }
}

/*!
 * \brief Client::nickName
 * \return
 *
 * Returns the value of \c peerManager->userName().
 */

QString Client::nickName() const {
    return QString(peerManager->userName());
}

/*!
 * \brief Client::getFile
 * \param fileData
 * \param fileName
 *
 * Emits a signal that notifies the \c Chat that we received a new file.
 */

void Client::getFile(const QByteArray &fileData, const QString &fileName) {
    emit newFile(fileData, fileName);
}

/*!
 * \brief Client::hasConnection
 * \param senderIp
 * \param senderPort
 * \return
 *
 * Verifies that we have a valid connection with a specific IP (\c senderIp)
 * and a specific port (\c senderPort).
 */

bool Client::hasConnection(const QHostAddress &senderIp, int senderPort) const {
    if (senderPort == -1)
        return message_peers.contains(senderIp);

    if (!message_peers.contains(senderIp))
        return false;

    QList<MConnection *> connections = message_peers.values(senderIp);
    foreach (MConnection *connection, connections) {
        if (connection->peerPort() == senderPort)
            return true;
    }

    return false;
}

/*!
 * \brief Client::newFileConnection
 * \param fc
 *
 * Configures the new \c FConnection by connecting some selected functions.
 */

void Client::newFileConnection(FConnection *fc) {
    connect(fc, SIGNAL(readyForUse()),  this, SLOT(readyForUseFile()));
    connect(fc, SIGNAL(disconnected()), this, SLOT(disconnectedFile()));
    connect(fc, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(connectionErrorFile(QAbstractSocket::SocketError)));
}

/*!
 * \brief Client::newMessageConnection
 * \param mc
 *
 * Does the same as \c Cluent::newFileConnection(FConenction) and
 * configures the greeting message of the new \c MConnection with the
 * format of username@profilepicture (the "@" is used later on to split the
 * greeting messages and obtain two \c QStrings).
 */

void Client::newMessageConnection(MConnection *mc) {
    mc->setGreetingMessage(peerManager->userName() + "@" + peerManager->face());
    connect(mc, SIGNAL(readyForUse()),  this, SLOT(readyForUseMsg()));
    connect(mc, SIGNAL(disconnected()), this, SLOT(disconnectedMsg()));
    connect(mc, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(connectionErrorMsg(QAbstractSocket::SocketError)));
}

/*!
 * \brief Client::readyForUseMsg
 *
 * Returns \c true if the new MConnection has been established correctly.
 * If so, we do some aditional configuration to the MConnection so that we
 * can receive messages from that connection.
 */

void Client::readyForUseMsg() {
    MConnection *connection = qobject_cast<MConnection *>(sender());
    if (!connection || hasConnection(connection->peerAddress(),
                                     connection->peerPort()))
        return;

    if (message_peers.contains(connection->peerAddress()))
        return;

    connect(connection, SIGNAL(newMessage(QString,QString, QString)), this,
            SIGNAL(newMessage(QString,QString, QString )));

    message_peers.insert(connection->peerAddress(), connection);
    emit newParticipant(connection->name(), connection->face());
}

/*!
 * \brief Client::disconnectedMsg
 *
 * Removes the selected MConnection using the \c Client::removeConnectionMsg() function.
 */

/*!
 * \brief Client::disconnectedMsg
 *
 * Removes the selected MConnection using the \c Client::removeConnectionMsg() function.
 */

void Client::disconnectedMsg() {
    if (MConnection *connection = qobject_cast<MConnection *>(sender()))
        removeConnectionMsg(connection);
}

/*!
 * \brief Client::connectionErrorMsg
 *
 * Removes the selected MConnection using the \c Client::removeConnectionMsg() function.
 */

void Client::connectionErrorMsg(QAbstractSocket::SocketError) {
    if (MConnection *connection = qobject_cast<MConnection *>(sender()))
        removeConnectionMsg(connection);
}

/*!
 * \brief Client::readyForUseFile
 *
 * Returns \c true if the new FConnection has been established correctly.
 * If so, we do some aditional configuration to the FConnection so that we
 * can receive files from that connection.
 */

void Client::readyForUseFile() {
    FConnection *connection = qobject_cast<FConnection *>(sender());
    if (!connection || hasConnection(connection->peerAddress(),
                                     connection->peerPort()))
        return;

    if (file_peers.contains(connection->peerAddress()))
        return;

    connect(connection, SIGNAL(newFile(QByteArray,QString)), this, SLOT(getFile(QByteArray,QString)));
    connect(connection, SIGNAL(updateProgress(QString,int)), this, SIGNAL(updateProgress(QString,int)));
    connect(connection, SIGNAL(newDownload(QString,QString,int)), this, SIGNAL(newDownload(QString,QString,int)));
    connect(connection, SIGNAL(downloadComplete(QString,QString)), this, SIGNAL(downloadComplete(QString,QString)));

    file_peers.insert(connection->peerAddress(), connection);
}

/*!
 * \brief Client::disconnectedFile
 *
 * Removes the selected FConnection using the \c Client::removeConnectionFile() function.
 */

void Client::disconnectedFile() {
    if (FConnection *connection = qobject_cast<FConnection *>(sender()))
        removeConnectionFile(connection);
}

/*!
 * \brief Client::connectionErrorFile
 *
 * Removes the selected FConnection using the \c Client::removeConnectionFile() function.
 */

void Client::connectionErrorFile(QAbstractSocket::SocketError) {
    if (FConnection *connection = qobject_cast<FConnection *>(sender()))
        removeConnectionFile(connection);
}

/*!
 * \brief Client::removeConnectionMsg
 * \param connection
 *
 * Removes the selected FConnection using the \c Client::removeConnectionFile() function.
 */

void Client::removeConnectionMsg(MConnection *connection) {
    if (message_peers.contains(connection->peerAddress())) {
        message_peers.remove(connection->peerAddress());
        emit participantLeft(connection->name());
    }

    connection->deleteLater();
}

/*!
 * \brief Client::removeConnectionFile
 * \param connection
 *
 * Removes the selected FConnection using the \c Client::removeConnectionFile() function.
 */

void Client::removeConnectionFile(FConnection *connection) {
    if (file_peers.contains(connection->peerAddress()))
        file_peers.remove(connection->peerAddress());

    connection->deleteLater();
}
