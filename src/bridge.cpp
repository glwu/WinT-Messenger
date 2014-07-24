//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
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
    // Prepare the variables for use
    lan_chat = false;

    // Check for updates only if the target system supports SSL.
    // For the moment, only iOS has trouble supporting SSL.
    // We need to use preprocessor directives because the build on
    // iOS would fail because we would need to create the Updater object,
    // which includes classes that try to initialize SSL features.
#if SSL_SUPPORT
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
    // Delete all registered chat objects inside the chat objects list
    qDeleteAll(chatObjects.begin(), chatObjects.end());
    chatObjects.clear();

    // Disable lan chat
    lan_chat = false;
}

/*!
 * \brief Bridge::startChat
 *
 * Creates and configures a new \c Chat object.
 */

void Bridge::startChat() {
    // First of all, stop any instances of the Chat object
    stopChat();

    // Create a new chat object and append it to the chat objects list
    chat = new Chat();
    chatObjects.append(chat);

    // Allow the chat interface to notify the QML interface when an user leaves.
    connect(chat, SIGNAL(delUser(QString)), this, SIGNAL (delUser(QString)));

    // Allow the QML interface to send a message string to the chat interface.
    connect(this, SIGNAL(returnPressed(QString)), chat,
                      SLOT(returnPressed(QString)));

    // Allow the chat interface to notify the QML interface when an user joins
    // the chat room.
    connect(chat, SIGNAL(newUser(QString, QString)), this,
                      SIGNAL (newUser(QString, QString)));

    // Notify the QML interface when a download is started.
    connect(chat, SIGNAL(newDownload(QString,QString,int)), this,
                      SIGNAL(newDownload(QString,QString,int)));

    // Notify the QML interface when a download is finished.
    connect(chat, SIGNAL(downloadComplete(QString,QString)), this,
                      SIGNAL(downloadComplete(QString,QString)));

    // Notify the QML interface when the progress of a download is updated.
    connect(chat, SIGNAL(updateProgress(QString,QString,int)), this,
                      SIGNAL(updateProgress(QString,QString,int)));

    // Allow the chat interface to notify the QML interface when a new message
    // is received.
    connect(chat, SIGNAL(newMessage(QString, QString, QString, char)), this,
                      SLOT(messagereceived(QString, QString, QString, char)));

    // Finally, enable the chat interface.
    lan_chat = true;
}

/*!
 * \brief Bridge::playSound
 *
 * Plays a sound when we receive a message.
 */

void Bridge::playSound() {
    // Play a popping sound when a new message is drawn.
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
    // Check for updates only if the target system supports SSL.
    if (SSL_SUPPORT)
        return updater->checkForUpdates();
    else
        return false;
}

/*!
 * \brief Bridge::shareFiles
 *
 * Creates a new \c QFileDialog and sends the selected files to
 * the \c Chat object using the \c Chat::shareFile() function.
 */

void Bridge::shareFiles() {
    // Only share files when LAN chat is enabled
    if (lan_chat) {

        // Get the selected items from the QFile dialog.
        QStringList filenames = QFileDialog::getOpenFileNames(0,
                                    tr("Select files"), QDir::homePath());

        // Get the number of selected files
        int count = filenames.count();

        // Get the number of selected files, this variable will decrease
        // each time that the sharing of an individual file is complete.
        int toUpload = filenames.count();

        // Send the selected files while toUpload is greater than 0
        while (toUpload > 0) {
            // Check that the file exists and send it
            if (!filenames.at(count - toUpload).isEmpty())
                chat->shareFile(filenames.at(count - toUpload));

            // Decrease the number of files that need to be uploaded
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
    // Save downloaded files on the SD card on Android
    // Save the downloaded files on the temporary directory on other
    // operating systems.
    if (ANDROID)
        return "/sdcard/Download/";
    else
        return QDir::tempPath() + "/";
}

/*!
 * \brief Bridge::saveChat
 *
 * Creates a new \c QFileDialog, creates a new file and writes the contents
 * of the chat log in that file.
 */

void Bridge::saveChat(const QString chat) {
    // Get the selected file location/name to save our chat log
    QString filename = QFileDialog::getSaveFileName(0, tr("Save chat"),
                           QDir::homePath(), "*.html");

    // Check that the file path is valid
    if (!filename.isEmpty()) {
        // Create a new file in the selected path
        QFile file(filename);

        // Write the contents of the chat log in the file
        if (file.open(QIODevice::WriteOnly))
            file.write(chat.toUtf8());

        // Close the file so that the OS can use it
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
 * \brief Bridge::messagereceived
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

void Bridge::messagereceived(const QString &from, const QString &face,
                             const QString &message, char localUser) {

    // Split the message to obtain the message and the color
    QList<QString> list = message.split("@color@");

    // Obtain the strings
    QString msg = list.at(0);
    QString color = "#00557f";

    // Avoid crashing the app when talking to peers with an older version of the app
    if (list.count() > 1)
        color = list.at(1);

    // Tweak the message to add scaled smiley images
    qreal size = manager.ratio(25);
    msg.replace("[s]", QString("<img width=%1 height=%1 src=qrc:/emotes/").arg(size));
    msg.replace("[/s]", ">");

    // Autodetect http:// links
    msg.replace(QRegExp("((?:https?)://\\S+)"), "<a href=\\1>\\1</a>");

    // Send the modified message to the QML interface
    emit drawMessage(from, face, msg, color, localUser);
}
