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
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
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

#include "../Headers/NetClient.h"

NetClient::NetClient() {
  peerManager = new NetPeerManager(this);
  peerManager->setServerPort(server.serverPort());
  peerManager->startBroadcasting();

  QObject::connect(peerManager, SIGNAL(newConnection(NetConnection*)), this, SLOT(newConnection(NetConnection*)));
  QObject::connect(&server,     SIGNAL(newConnection(NetConnection*)), this, SLOT(newConnection(NetConnection*)));
}

void NetClient::sendMessage(const QString &message) {
  if (!message.isEmpty()) {
      QList<NetConnection *> connections = peers.values();
      foreach (NetConnection *connection, connections)
        connection->sendMessage(message);
    }
}

void NetClient::sendFile(const QString &fileName) {
  if (!fileName.isEmpty()) {
      QList<NetConnection *> connections = peers.values();
      foreach (NetConnection *connection, connections) {
          connection->sendMessage(MessageManager::formatNotification(QString("%1 shared %2")
                                                                     .arg(nickName(),
                                                                          QFileInfo(QFile(fileName)).fileName())));
          connection->sendFile(fileName);
        }
    }
}

QString NetClient::nickName() const {
  return QString(peerManager->userName());
}

bool NetClient::hasConnection(const QHostAddress &senderIp, int senderPort) const {
  if (senderPort == -1)
    return peers.contains(senderIp);

  if (!peers.contains(senderIp))
    return false;

  QList<NetConnection *> connections = peers.values(senderIp);
  foreach (NetConnection *connection, connections) {
      if (connection->peerPort() == senderPort)
        return true;
    }

  return false;
}

void NetClient::getFile(const QByteArray &fileData, const QString &fileName) {
  emit newFile(fileData, fileName);
}

void NetClient::newConnection(NetConnection *connection) {
  connection->setGreetingMessage(peerManager->userName());

  connect(connection, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(connectionError(QAbstractSocket::SocketError)));
  connect(connection, SIGNAL(disconnected()),                      this, SLOT(disconnected()));
  connect(connection, SIGNAL(readyForUse()),                       this, SLOT(readyForUse()));
}

void NetClient::readyForUse() {
  NetConnection *connection = qobject_cast<NetConnection *>(sender());
  if (!connection || hasConnection(connection->peerAddress(), connection->peerPort()))
    return;

  connect(connection, SIGNAL(newMessage(QString)),         this, SIGNAL(newMessage(QString)));
  connect(connection, SIGNAL(newFile(QByteArray,QString)), this, SLOT(getFile(QByteArray,QString)));
  peers.insert(connection->peerAddress(), connection);

  const QString &nick = connection->name();
  if (!nick.isEmpty())
    emit newParticipant(nick);
}

void NetClient::disconnected() {
  if (NetConnection *connection = qobject_cast<NetConnection *>(sender()))
    removeConnection(connection);
}

void NetClient::connectionError(QAbstractSocket::SocketError) {
  if (NetConnection *connection = qobject_cast<NetConnection *>(sender()))
    removeConnection(connection);
}

void NetClient::removeConnection(NetConnection *connection) {
  if (peers.contains(connection->peerAddress())) {
      peers.remove(connection->peerAddress());

      const QString &nick = connection->name();
      if (!nick.isEmpty())
        emit participantLeft(nick);
    }

  connection->deleteLater();
}
