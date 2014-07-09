//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "bridge.h"

/*!
 * \brief Bridge::Bridge
 *
 * Initializes the \c Bridge and (if the OS is not iOS),
 * configures the \c Updater.
 */

Bridge::Bridge() {
    lan_chat = false;

#ifndef Q_OS_IOS
    updater = new Updater();
    connect(updater, SIGNAL(updateAvailable()), this, SIGNAL(updateAvailable()));
#endif
}

/*!
 * \brief Bridge::stopChat
 *
 * Stops the current \c Chat object and deletes it.
 */

void Bridge::stopChat() {
    qDeleteAll(chatObjects.begin(), chatObjects.end());
    chatObjects.clear();
    lan_chat = false;
}

/*!
 * \brief Bridge::startChat
 *
 * Creates and configures a new \c Chat object.
 */

void Bridge::startChat() {
    stopChat();

    chat = new Chat();
    chatObjects.append(chat);
    chat->setDownloadPath(getDownloadPath());

    QObject::connect(chat, SIGNAL(delUser(QString)), this,
                     SIGNAL(delUser(QString)));
    QObject::connect(this, SIGNAL(returnPressed(QString)), chat,
                     SLOT(returnPressed(QString)));
    QObject::connect(chat, SIGNAL(newUser(QString, QString)), this,
                     SIGNAL(newUser(QString, QString)));
    QObject::connect(chat, SIGNAL(newMessage(QString, QString, QString, char)),
                     this, SLOT(messageRecieved(QString, QString, QString, char)));

    lan_chat = true;
}

/*!
 * \brief Bridge::playSound
 *
 * Plays a sound when we receive a message.
 */

void Bridge::playSound() {
    QSound::play(":/sounds/message.wav");
}

/*!
 * \brief Bridge::checkForUpdates
 * \return
 *
 * Tells the \c Updater to check for updates
 * using the \
 c Updater::checkForUpdates() function.
 */

bool Bridge::checkForUpdates() {
#ifndef Q_OS_IOS
    return updater->checkForUpdates();
#else
    return false;
#endif
}

/*!
 * \brief Bridge::shareFiles
 *
 * Creates a new \c QFileDialog and sends the selected files to
 * the \c Chat object using the \c Chat::shareFile() function.
 */

void Bridge::shareFiles() {
    if (lan_chat) {
        QStringList filenames = QFileDialog::getOpenFileNames(0, tr("Select files"), QDir::homePath());

        int count = filenames.count();
        int toUpload = filenames.count();

        while (toUpload > 0) {
            if (!filenames.at(count - toUpload).isEmpty())
                chat->shareFile(filenames.at(count - toUpload));
            toUpload -= 1;
        }
    }
}

/*!
 * \brief Bridge::getDownloadPath
 * \return
 *
 * Returns a directory to write the downloaded files:
 *  - "/sdcard/Download/" on Android
 *  - Temporary files directory on other operating systems
 */

QString Bridge::getDownloadPath() {
#if defined(Q_OS_ANDROID)
    return "/sdcard/Download/";
#else
    return QDir::tempPath() + "/";
#endif
}

/*!
 * \brief Bridge::saveChat
 *
 * Creates a new \c QFileDialog, creates a new file and writes the contents
 * of the chat log in that file.
 */

void Bridge::saveChat(const QString chat) {
    QString filename = QFileDialog::getSaveFileName(0, tr("Save chat"), QDir::homePath(), "*.html");

    if (!filename.isEmpty()) {
        QFile file(filename);

        if (file.open(QIODevice::WriteOnly))
            file.write(chat.toUtf8());

        file.close();
    }
}

/*!
 * \brief Bridge::sendMessage
 * \param message
 *
 * Emits a \c returnPressed() when called.
 */

void Bridge::sendMessage(const QString message) {
    emit returnPressed(message);
}

/*!
 * \brief Bridge::messageRecieved
 * \param from
 * \param face
 * \param message
 * \param localUser
 *
 * Prepares and formats the message in HTML and then sends it to QML interface.
 * The output message contains:
 *  - Emoticons
 *  - Auto-generated HTML links
 */

void Bridge::messageRecieved(const QString &from, const QString &face,
                             const QString &message, char localUser) {

    // Split the message to obtain the message and the color
    QList<QString> list = message.split("@color@");

    // Obtain the strings
    QString msg = list.at(0);
    QString color = "#00557f";

    // Avoid crashing the app when talking to peers with an older version of the app
    if (list.count() > 1)
        color = list.at(1);

    // Tweak the message
    qreal size = manager.ratio(25);
    msg.replace("[s]", QString("<img width=%1 height=%1 src=qrc:/emotes/").arg(size));
    msg.replace("[/s]", ">");
    msg.replace(QRegExp("((?:https?)://\\S+)"), "<a href=\\1>\\1</a>");

    emit drawMessage(from, face, msg, color, localUser);
}
