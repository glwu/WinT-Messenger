//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "qchat.h"

/*!
 * \brief QChat::QChat
 *
 * Initializes the \c Chat object and connects the neccesary slots for
 * comunication with the \c Client object.
 */

QChat::QChat() {
    // Notify our parent when a participant has left the conversation
    connect(&client, SIGNAL(participantLeft(QString)), this,
            SIGNAL(delUser(QString)));

    // Notify our parent when a new user has joined the conversation
    connect(&client, SIGNAL(newParticipant(QString,QString)), this,
            SIGNAL(newUser(QString,QString)));

    // Notify our parent when a new download has begun
    connect(&client, SIGNAL(newDownload(QString,QString,int)), this,
            SIGNAL(newDownload(QString,QString,int)));

    // Notify our parent when a download is complete
    connect(&client, SIGNAL(downloadComplete(QString,QString)), this,
            SIGNAL(downloadComplete(QString,QString)));

    // Notify our parent when the progress of a download changes
    connect(&client, SIGNAL(updateProgress(QString,QString,int)), this,
            SIGNAL(updateProgress(QString,QString,int)));

    // Notify our parent when a new message has been received and processed
    connect(&client, SIGNAL(newMessage(QString,QString,QString)), this,
            SLOT(messageReceived(QString,QString,QString)));

    // This are the default (and fallback) values
    color = "#336699";
    setNickname("unknown");
    setUserFace("astronaut.jpg");

    // This is the default (and fallback) directory where we should save our
    // downloaded files.
    QDir dir;
    dir.mkdir(dir.homePath() + "/Downloads");
    setDownloadPath(dir.homePath() + "/Downloads");
}

/*!
 * \brief QChat::setColor
 * \param color
 *
 * Defines the color of the user
 */

void QChat::setColor(const QString &color) {
    this->color = color;
}

/*!
 * \brief QChat::setNickname
 * \param nick
 *
 * Sets the nickname of the user
 */

void QChat::setNickname(const QString &nick) {
    client.setNickname(nick);
}

/*!
 * \brief QChat::setUserFace
 * \param face
 *
 * Sets the profile picture of the user
 */

void QChat::setUserFace(const QString &face) {
    client.setUserFace(face);
}

/*!
 * \brief QChat::setDownloadPath
 * \param path
 *
 * Defines where the program should save the downloaded files
 */

void QChat::setDownloadPath(const QString &path) {
    client.setDownloadPath(path);
}

/*!
 * \brief QChat::getDownloadPath
 * \return
 *
 * Returns the value of downloadPath
 */

QString QChat::getDownloadPath() {
    return downloadPath;
}

/*!
 * \brief QChat::shareFile
 * \param path
 *
 * Sends the file path to the \c Client and sends a
 * processed message to the \c Bridge.
 */

void QChat::shareFile(const QString &path) {
    client.sendFile(path);

    QFile file(path);
    emit newMessage(client.nickName(), "system/package.png",
                    QString("You shared <a href='file://%1'>%2</a>")
                    .arg(path, QFileInfo(file).fileName()), color, 1);

    file.close();
}

/*!
 * \brief QChat::returnPressed
 * \param message
 *
 * Replaces the symbols "<" and ">" with their HTML equivalents
 * ("&lt;" and "&gt;"), sends the message to the \c Client and
 * sends the processed message to the \c Bridge.
 */

void QChat::returnPressed(const QString &message) {
    QString msg = message + "@color@" + color;

    msg.replace("<", "&lt;");
    msg.replace(">", "&gt;");

    msg.replace(QRegExp("((?:https?)://\\S+)"), "<a href=\\1>\\1</a>");

    client.sendMessage(msg);
    emit newMessage(client.nickName(), QString(client.peerManager->face()),
                    message, color, 1);
}

/*!
 * \brief QChat::messageReceived
 * \param from
 * \param face
 * \param message
 *
 * Extracts the color data from the message and sends the modified message to the \c Bridge
 */

void QChat::messageReceived(const QString &from, const QString &face,
                            const QString &message) {

    QList<QString> list = message.split("@color@");

    QString msg = list.at(0);
    QString color = "#00557f";

    if (list.count() > 1)
        color = list.at(1);

    msg.replace(QRegExp("((?:https?)://\\S+)"), "<a href=\\1>\\1</a>");
    emit newMessage(from, face, msg, color, 0);
}
