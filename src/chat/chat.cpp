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
    connect(&client, SIGNAL(participantLeft(QString)), this, SLOT(participantLeft(QString)));
    connect(&client, SIGNAL(newFile(QByteArray,QString)), this, SLOT(receivedFile(QByteArray,QString)));
    connect(&client, SIGNAL(newParticipant(QString,QString)), this, SLOT(newParticipant(QString,QString)));
    connect(&client, SIGNAL(newMessage(QString,QString,QString)), this, SLOT(messageReceived(QString,QString,QString)));
    connect(&client, SIGNAL(newDownload(QString,QString,int)), this, SIGNAL(newDownload(QString,QString,int)));
    connect(&client, SIGNAL(downloadComplete(QString,QString)), this, SIGNAL(downloadComplete(QString,QString)));
    connect(&client, SIGNAL(updateProgress(QString,int)), this, SIGNAL(updateProgress(QString,int)));

    QSettings settings("WinT 3794", "WinT Messenger");
    userColor = settings.value("userColor", "#428bca").toString();
}

/*!
 * \brief Chat::setDownloadPath
 * \param path
 *
 * Changes the directory where we save received files based on the
 * \c path parameter.
 */

void Chat::setDownloadPath(const QString &path) {
    downloadPath = path;
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
    QString msg = message + "@color@" + userColor;
    msg.replace("<", "&lt;");
    msg.replace(">", "&gt;");

    client.sendMessage(msg);
    emit newMessage(client.nickName(), QString(client.peerManager->face()), msg, 1);
}

/*!
 * \brief Chat::shareFile
 * \param path
 *
 * Sends the file path to the \c Client and sends the
 * processed message to the \c Bridge.
 */

void Chat::shareFile(const QString &path) {
    client.sendFile(path);

    QFile file(path);
    emit newMessage(client.nickName(), "system/package.png",
                    QString("You shared <a href='file://%1'>%2</a>")
                    .arg(path, QFileInfo(file).fileName()), 1);
}

/*!
 * \brief Chat::newParticipant
 * \param nick
 * \param face
 *
 * Sends information about the new peer to the \c Bridge and sends a message to the \c Bridge
 * that notifies the user that the user has joined the room.
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
 * \brief Chat::receivedFile
 * \param data
 * \param fileName
 *
 * Uncompresses the \c data, creates a file in the \c downloadPath directory,
 * writes the \c data to the file and sends a message to the \c Bridge that
 * notifies the user that the download is complete.
 */

void Chat::receivedFile(const QByteArray &data, const QString &fileName) {
    QByteArray uncompressedData = qUncompress(data);

    QFile file(downloadPath + fileName);
    if (file.open(QFile::WriteOnly))
        file.write(uncompressedData);

    uncompressedData.clear();
    file.close();
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
