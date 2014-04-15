//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "../Headers/NetChat.h"

NetChat::NetChat() {
    connect(&client, SIGNAL(newParticipant(QString)),  this, SLOT(newParticipant(QString)));
    connect(&client, SIGNAL(participantLeft(QString)), this, SLOT(participantLeft(QString)));
    connect(&client, SIGNAL(newMessage(QString)),      this, SIGNAL(newMessage(QString)));
}

void NetChat::returnPressed(QString text) {
    client.sendMessage(MessageManager::formatMessage(text, client.nickName()));
    emit newMessage(MessageManager::formatMessage(text, client.nickName()));
}

void NetChat::shareFile() {
}

void NetChat::newParticipant(const QString &nick) {
    emit newMessage(MessageManager::formatNotification("%1 has joined").arg(nick));
    emit newUser(nick);
}

void NetChat::participantLeft(const QString &nick) {
    emit newMessage(MessageManager::formatNotification("%1 has left").arg(nick));
    emit delUser(nick);
}