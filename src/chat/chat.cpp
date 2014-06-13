//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "chat.h"

//===========================================================================//
//When the chat module initializes, we connect the SIGNALS proceding from the//
//client module to the Bridge, thus sending information to the QML interface.//
//===========================================================================//

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

//================================================================//
//The downloadPath string tells us where to save downloaded files.//
//================================================================//

void Chat::setDownloadPath(const QString &path) {
    downloadPath = path;
}

//==========================================================================//
//The message is sent from the QML interface to the bridge and finally, here//
//We need to adjust the message to avoid HTML displaying errors and then we //
//send it to the peers that we are connected to.                            //
//==========================================================================//

void Chat::returnPressed(const QString &message) {
    QString msg = message;
    msg.replace("<", "&lt;");
    msg.replace(">", "&gt;");

    client.sendMessage(msg);

    emit newMessage(client.nickName(),
                    QString(client.peerManager->face()), msg, 1);
}

//===========================================================================//
//The proccess of sharing a file is similar to sending a message: the file is//
//selected in the QML interface, then a string containing the path is sent to//
//the Bridge and then the Bridge sends the string here, where we will send it//
//to our peers & post a message to the user informing that the file was sent.//
//===========================================================================//

void Chat::shareFile(const QString &fileName) {
    client.sendFile(fileName);

    QFile file(fileName);
    emit newMessage(0,"system/package.png",
                    QString("You shared <a href='file:///%1'>%2</a>")
                    .arg(fileName, QFileInfo(file).fileName()), 1);
}

//=====================================================================//
//Functions that inform the user when an user joins or leaves the room.//
//=====================================================================//

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

//===========================================================================//
//Functions that deal with the steps that are taken when we receive a message//
//or a file from another peer.                                               //
//===========================================================================//

void Chat::receivedFile(const QByteArray &data, const QString &fileName) {
    QFile file(downloadPath + fileName);
    if (file.open(QFile::ReadWrite))
        file.write(data);

    // Notify the user of the downloaded file
    emit newMessage(0, "system/package.png",
                    QString("Received <a href='file:///%1'>%2</a>")
                    .arg(file.fileName())
                    .arg(fileName), 0);

    // Close the file
    file.close();
}

void Chat::messageReceived(const QString &from, const QString &face, const QString &message) {
    emit newMessage(from, face, message, 0);
}
