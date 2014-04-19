//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "../Headers/NetChat.h"

NetChat::NetChat() {
  connect(&client, SIGNAL(newParticipant(QString)),     this, SLOT(newParticipant(QString)));
  connect(&client, SIGNAL(participantLeft(QString)),    this, SLOT(participantLeft(QString)));
  connect(&client, SIGNAL(newFile(QByteArray,QString)), this, SLOT(receivedFile(QByteArray,QString)));
  connect(&client, SIGNAL(newMessage(QString)),         this, SIGNAL(newMessage(QString)));
}

void NetChat::returnPressed(const QString &text) {
  client.sendMessage(MessageManager::formatMessage(text, client.nickName()));
  emit newMessage(MessageManager::formatMessage(text, client.nickName()));
}

void NetChat::shareFile(const QString &fileName) {
  client.sendFile(fileName);
  emit newMessage(MessageManager::formatNotification(QString("You shared <a href=\"%1\">%2</a>")
                                                     .arg(fileName, QFileInfo(QFile(fileName)).fileName())));
}

void NetChat::newParticipant(const QString &nick) {
  emit newMessage(MessageManager::formatNotification("%1 has joined").arg(nick));
  emit newUser(nick);
}

void NetChat::participantLeft(const QString &nick) {
  emit newMessage(MessageManager::formatNotification("%1 has left").arg(nick));
  emit delUser(nick);
}

void NetChat::receivedFile(const QByteArray &data, const QString &fileName) {
  QFile file(QDir::tempPath() + "/" + fileName);
  if (file.open(QFile::ReadWrite))
    file.write(data);

  QString message = QString("Received <a href=\"%1\">%2</a>").arg(file.fileName(), fileName);
  newMessage(MessageManager::formatNotification(message));
  file.close();
}
