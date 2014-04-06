//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "../Headers/NetChat.h"

using namespace std;

NetChat::NetChat() {
    connect(&client, SIGNAL(newParticipant(QString)),  this, SLOT(newParticipant(QString)));
    connect(&client, SIGNAL(participantLeft(QString)), this, SLOT(participantLeft(QString)));
    connect(&client, SIGNAL(newMessage(QString)),      this, SIGNAL(newMessage(QString)));

    QSettings *settings = new QSettings("WinT Messenger");
    color = settings->value("userColor", "#00557f").toString();
}

void NetChat::returnPressed(QString text) {
    client.sendMessage(prepareMessage(text));
    newMessage(prepareMessage(text));
}

void NetChat::sendFile(QString fileName) {
}

void NetChat::newParticipant(const QString &nick) {
    newMessage(QString("<i><font color = 'gray'>%1 has joined</font></i>").arg(nick));
    newUser(nick);
}

void NetChat::participantLeft(const QString &nick) {
    newMessage(QString("<i><font color = 'gray'>%1 has left</font></i>").arg(nick));
    delUser(nick);
}

QString NetChat::prepareMessage(const QString message) {
    return "<font color = '" + color + "'>"
            + "[" + QDateTime::currentDateTime().toString("hh:mm:ss") + "] "
            + "&lt;" + client.nickName() + "&gt;&nbsp; </font>"
            + message;
}
