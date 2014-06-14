//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "chat.h"

Chat::Chat() {
    connect(&client, SIGNAL(participantLeft(QString)), this,
            SLOT(participantLeft(QString)));
    connect(&client, SIGNAL(newFile(QByteArray,QString)), this,
            SLOT(receivedFile(QByteArray,QString)));
    connect(&client, SIGNAL(newParticipant(QString,QString)), this,
            SLOT(newParticipant(QString,QString)));
    connect(&client, SIGNAL(newMessage(QString,QString,QString)), this,
            SLOT(messageReceived(QString,QString,QString)));
}

void Chat::setDownloadPath(const QString &path) {
    downloadPath = path;
}

void Chat::returnPressed(const QString &message) {
    QString msg = message;
    msg.replace("<", "&lt;");
    msg.replace(">", "&gt;");

    client.sendMessage(msg);

    emit newMessage(client.nickName(),
                    QString(client.peerManager->face()), msg, 1);
}

void Chat::shareFile(const QString &fileName) {
    client.sendFile(fileName);

    QFile file(fileName);
    emit newMessage(0,"system/package.png",
                    QString("You shared <a href='file:///%1'>%2</a>")
                    .arg(fileName, QFileInfo(file).fileName()), 1);
}

void Chat::newParticipant(const QString &nick, const QString &face) {
    emit newUser(nick, face);
    emit newMessage(0, "system/info.png",
                    QString("%1 has joined").arg(nick), 0);
}

void Chat::participantLeft(const QString &nick) {
    emit delUser(nick);
    emit newMessage(0, "system/info.png",
                    QString("%1 has left").arg(nick), 0);
}

void Chat::receivedFile(const QByteArray &data, const QString &fileName) {
    QFile file(downloadPath + fileName);
    if (file.open(QFile::ReadWrite))
        file.write(data);

    emit newMessage(0, "system/package.png",
                    QString("Received <a href='file:///%1'>%2</a>")
                    .arg(file.fileName())
                    .arg(fileName), 0);

    file.close();
}

void Chat::messageReceived(const QString &from, const QString &face, const QString &message) {
    emit newMessage(from, face, message, 0);
}
