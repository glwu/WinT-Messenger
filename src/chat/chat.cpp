//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "chat.h"

/*!
 * \brief Chat::Chat
 *
 * Initializes the \c Chat object and connects the neccesary slots for
 * comunication with the \c Client object.
 */

Chat::Chat() {
    // Establish the communication layers between the client and the bridge
    connect(&client, SIGNAL(participantLeft(QString)), this,
                     SLOT(participantLeft(QString)));
    connect(&client, SIGNAL(newParticipant(QString,QString)), this,
                     SLOT(newParticipant(QString,QString)));
    connect(&client, SIGNAL(newMessage(QString,QString,QString)), this,
                     SLOT(messageReceived(QString,QString,QString)));
    connect(&client, SIGNAL(newDownload(QString,QString,int)), this,
                     SIGNAL(newDownload(QString,QString,int)));
    connect(&client, SIGNAL(downloadComplete(QString,QString)), this,
                     SIGNAL(downloadComplete(QString,QString)));
    connect(&client, SIGNAL(updateProgress(QString,QString,int)), this,
                     SIGNAL(updateProgress(QString,QString,int)));

    // Load the user color
    QSettings settings("WinT 3794", "WinT Messenger");
    userColor = settings.value("userColor", "#336699").toString();
}

/*!
 * \brief Chat::returnPressed
 * \param message
 *
 * Replaces the symbols "<" and ">" with their HTML equivalents
 * ("&lt;" and "&gt;"), sends the message to the \c Client and
 * sends the processed message to the \c Bridge.
 */

void Chat::returnPressed(const QString &message) {
    // Append the profile color to the message
    QString msg = message + "@color@" + userColor;

    // Replace "<" and ">" with their HTML equivalents to avoid screwing up
    // the QML interface (because the messages are displayed in HTML)
    msg.replace("<", "&lt;");
    msg.replace(">", "&gt;");

    // Send the message to all connected users
    client.sendMessage(msg);

    // Draw the modified message in the QML interface as the local user
    emit newMessage(client.nickName(), QString(client.peerManager->face()), msg, 1);
}

/*!
 * \brief Chat::shareFile
 * \param path
 *
 * Sends the file path to the \c Client and sends a
 * processed message to the \c Bridge.
 */

void Chat::shareFile(const QString &path) {
    // Send the file to all connected users, note that the file is actually read
    // in the FConnection class ($PWD/file-connection/f_connection.cpp)
    client.sendFile(path);

    // Get the name of the file to notify the sender of the file that the
    // file was shared.
    QFile file(path);
    emit newMessage(client.nickName(), "system/package.png",
                    QString("You shared <a href='file://%1'>%2</a>")
                    .arg(path, QFileInfo(file).fileName()), 1);

    // Close the file so that other programs/OS can use it.
    file.close();
}

/*!
 * \brief Chat::newParticipant
 * \param nick
 * \param face
 *
 * Sends information about the new peer to the \c Bridge and sends a message
 * to the \c Bridge that notifies the user that the user has joined the room.
 */

void Chat::newParticipant(const QString &nick, const QString &face) {
    emit newUser(nick, face);
}

/*!
 * \brief Chat::participantLeft
 * \param nick
 *
 * Sends the peer's information to the \c Bridge and sends a message to the \c Bridge
 * that notifies the user that the peer has left.
 */

void Chat::participantLeft(const QString &nick) {
    emit delUser(nick);
}

/*!
 * \brief Chat::messageReceived
 * \param from
 * \param face
 * \param message
 *
 * Sends a new message to the \c Bridge with the \c message, \c from (peer name)
 * \c face (peer's profile picture).
 */

void Chat::messageReceived(const QString &from, const QString &face, const QString &message) {
    emit newMessage(from, face, message, 0);
}
