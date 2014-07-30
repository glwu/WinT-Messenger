//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "bridge.h"

/// Initializes and configures the Bridge class
Bridge::Bridge() {
    qchat_enabled = false;
    xmppchat_enabled = false;

#if SSL_SUPPORT
    updater = new Updater();
    connect(updater, SIGNAL(updateAvailable()), this, SIGNAL(updateAvailable()));
#endif
}

/// LAN CHAT FUNCTIONS
/// ==============================================================================
/// These functions are only used while dealling with the qChat module

/// Stops and deletes the current qChat module
void Bridge::stopLanChat() {
    qDeleteAll(qChatObjects.begin(), qChatObjects.end());
    qChatObjects.clear();
    qchat_enabled = false;
}

/// Initializes and configures a new qChat module
void Bridge::startLanChat() {
    stopLanChat();

    qchat = new QChat();
    qChatObjects.append(qchat);

    QSettings settings("WinT 3794", "WinT Messenger");
    qchat->setColor(settings.value("userColor", "#336699").toString());
    qchat->setNickname(settings.value("username", "unknown").toString());
    qchat->setUserFace(settings.value("face", "astronaut.jpg").toString());

    connect(qchat, SIGNAL(delUser(QString)), this, SIGNAL (delUser(QString)));
    connect(this, SIGNAL(returnPressed(QString)), qchat,
            SLOT(returnPressed(QString)));
    connect(qchat, SIGNAL(newUser(QString, QString)), this,
            SIGNAL (newUser(QString, QString)));
    connect(qchat, SIGNAL(newDownload(QString,QString,int)), this,
            SIGNAL(newDownload(QString,QString,int)));
    connect(qchat, SIGNAL(downloadComplete(QString,QString)), this,
            SIGNAL(downloadComplete(QString,QString)));
    connect(qchat, SIGNAL(updateProgress(QString,QString,int)), this,
            SIGNAL(updateProgress(QString,QString,int)));
    connect(qchat, SIGNAL(newMessage(QString,QString,QString,QString,char)),
            this, SLOT(messageReceived(QString,QString,QString,QString,char)));

    qchat_enabled = true;
}

/// XMPP CHAT FUNCTIONS
/// ==============================================================================
/// These functions are only used while dealing with the XmppChat module

/// Stops the XMPP Chat module and deletes it
void Bridge::stopXmppChat() {
    qDeleteAll(xmppChatObjects.begin(), xmppChatObjects.end());
    xmppChatObjects.clear();
    xmppchat_enabled = false;
}

/// Starts and configures the XMPP chat module.
///
/// \param jid JID for the account.
/// \param password Password for the account.
bool Bridge::startXmppChat(QString jid, QString passwd) {
    stopXmppChat();

    xmppChat = new XmppChat();
    xmppChatObjects.append(xmppChat);

    if (xmppChat->login(jid, passwd)) {
        return true;
    }

    return false;
}

/// COMMON CHAT FUNCTIONS
/// ==============================================================================
/// These functions are used while using both chat modules

/// Plays a sound when a new message is processed
void Bridge::playSound() {
    QSound::play(":/sounds/message.wav");
}

/// Opens a file and shares it depending on which module is enabled
void Bridge::shareFiles() {
    QStringList filenames = QFileDialog::getOpenFileNames(0, tr("Select files"),
                                                          QDir::homePath());
    int count = filenames.count();
    int toUpload = filenames.count();

    if (qchat_enabled) {
        while (toUpload > 0) {
            if (!filenames.at(count - toUpload).isEmpty())
                qchat->shareFile(filenames.at(count - toUpload));

            toUpload -= 1;
        }
    }

    else if (xmppchat_enabled) {

    }
}

/// Saves the chat log as an HTML file
///
/// \param chat for the chat log string
void Bridge::saveChat(QString chat) {
    QString filename = QFileDialog::getSaveFileName(0, tr("Save chat"),
                                                    QDir::homePath(), "*.html");

    if (!filename.isEmpty()) {
        QFile file(filename);
        if (file.open(QIODevice::WriteOnly))
            file.write(chat.toUtf8());

        file.close();
    }
}

/// Sends a message to the QML interface and to the
/// current chat module.
///
/// \param message
void Bridge::sendMessage(QString message) {
    emit returnPressed(message);
}

/// Processes the message and displays it in the QML interface
///
/// \param from for the sender name (string) of the message
/// \param face for the profile picture of the sender
/// \param message for the message of the sender
/// \param color for the profile color of the sender
/// \param localUser 1 if the sender is the local user, 0 if the sender is a peer.
void Bridge::messageReceived(QString from, QString face, QString message,
                             QString color, char localUser) {
    qreal size = manager.ratio(25);
    message.replace("[s]", QString("<img width=%1 height=%1 src=qrc:/emotes/")
                    .arg(size));
    message.replace("[/s]", ">");

    emit drawMessage(from, face, message, color, localUser);
}

/// OTHER FUNCTIONS
/// ==============================================================================

/// Returns the folder in which we should save downloaded files
QString Bridge::getDownloadPath() {
    if (ANDROID)
        return "/sdcard/Download/";
    else
        return QDir::tempPath() + "/";
}

/// Checks for application updates and returns \c true if
/// a new update is available.
bool Bridge::checkForUpdates() {
    if (SSL_SUPPORT)
        return updater->checkForUpdates();
    else
        return false;
}
