//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "bridge.h"

Bridge::Bridge()
{
    // Set default values
    m_xmpp_enabled = false;
    m_qchat_enabled = false;

    // Create the image provider, which is used to
    // load images dynamically in the QML interface
    imageProvider = new ImageProvider;

    // Create a clipboard manager, which is used
    // to enable all "Copy" events for the QML interface
    m_clipboard = QApplication::clipboard();

    // Create and configure the application updater
    m_updater = new Updater();
    connect (m_updater, SIGNAL (updateAvailable(bool, QString)),
             this,      SIGNAL (updateAvailable(bool, QString)));
}

void Bridge::stopLanChat()
{
    // Delete all registered instances of QChat.
    // Theoretically, we should not have more than one running
    // instance....
    qDeleteAll (m_qchat_objects.begin(), m_qchat_objects.end());
    m_qchat_objects.clear();
    m_qchat_enabled = false;

    // Reset all users
    m_uuids.clear();
    m_nicknames.clear();

    // Remove all profile pictures
    imageProvider->clearImages();
}

void Bridge::startLanChat()
{
    // Stop any previous instances of QChat
    stopLanChat();

    // Create and configure a new instance of QChat
    m_qchat = new QChat();

    if (m_qchat != NULL)
    {
        m_qchat_enabled = true;
        m_qchat_objects.append (m_qchat);

        // Get user name and profile picture from saved settings
        QSettings _settings ("WinT 3794", "WinT Messenger");
        QString _nickname = _settings.value ("nickname", "unknown").toString();
        QImage _profilePicture (":/faces/faces/" +
                                _settings.value ("face", "astronaut.jpg").toString());

        // Apply nickname and profile picture
        m_qchat->setNickname (_nickname);
        m_qchat->setProfilePicture (_profilePicture);

        // Specify where we should write downloaded files
        m_qchat->setDownloadPath (downloadPath());

        // Register the local user's profile picture with the
        // image provider
        imageProvider->addImage (_profilePicture, _nickname);

        // Communicate QChat instance with QML interface
        connect (m_qchat, SIGNAL (delUser (QString, QString)),
                 this,    SIGNAL (delUser (QString, QString)));
        connect (m_qchat, SIGNAL (newUser (QString, QString, QImage)),
                 this,    SLOT   (processNewUser (QString, QString, QImage)));
        connect (m_qchat, SIGNAL (newDownload (QString, QString, int)),
                 this,    SIGNAL (newDownload (QString, QString, int)));
        connect (m_qchat, SIGNAL (downloadComplete (QString, QString)),
                 this,    SIGNAL (downloadComplete (QString, QString)));
        connect (m_qchat, SIGNAL (updateProgress (QString, QString, int)),
                 this,    SIGNAL (updateProgress (QString, QString, int)));
        connect (m_qchat, SIGNAL (newMessage  (QString, QString)),
                 this,    SIGNAL (drawMessage (QString, QString)));
        connect (m_qchat, SIGNAL (statusChanged (QString, QString)),
                 this,    SIGNAL (statusChanged (QString, QString)));

        connect (this,    SIGNAL (returnPressed (QString, QString)),
                 m_qchat, SLOT   (returnPressed (QString, QString)));
        connect (this,    SIGNAL (sendFile  (QString,QString)),
                 m_qchat, SLOT   (shareFile (QString,QString)));
        connect (this,    SIGNAL (sendStatusSignal  (QString,QString)),
                 m_qchat, SLOT   (sendStatus        (QString,QString)));
    }
}

void Bridge::stopXmpp()
{
    // Delete all registered instances of Xmpp.
    // Theoretically, we should not have more than one running
    // instance....
    qDeleteAll (m_xmpp_objects.begin(), m_xmpp_objects.end());
    m_xmpp_objects.clear();
    m_xmpp_enabled = false;

    // Reset users
    m_uuids.clear();
    m_nicknames.clear();

    // Remove all profile pictures
    imageProvider->clearImages();
}

void Bridge::startXmpp (QString jid, QString passwd)
{
    // Stop any previous instances of QChat
    stopXmpp();

    // Create and configure a new instance of Xmpp
    m_xmpp = new Xmpp();

    if (m_xmpp != NULL)
    {
        m_xmpp_enabled = true;
        m_xmpp_objects.append (m_xmpp);

        // Establish a communication layer between QML interface
        // and Xmpp instance
        connect (m_xmpp, SIGNAL (connected()),
                 this,   SIGNAL (xmppConnected()));
        connect (m_xmpp, SIGNAL (disconnected()),
                 this,   SIGNAL (xmppDisconnected()));
        connect (m_xmpp, SIGNAL (delUser (QString, QString)),
                 this,   SIGNAL (delUser (QString, QString)));
        connect (m_xmpp, SIGNAL (newMessage  (QString, QString)),
                 this,   SIGNAL (drawMessage (QString, QString)));
        connect (m_xmpp, SIGNAL (newUser        (QString, QString, QImage)),
                 this,   SLOT   (processNewUser (QString, QString, QImage)));

        connect (this,   SIGNAL (returnPressed (QString, QString)),
                 m_xmpp, SLOT   (sendMessage   (QString, QString)));
        connect (this,   SIGNAL (sendFile  (QString,QString)),
                 m_xmpp, SLOT   (shareFile (QString,QString)));
        connect (this,   SIGNAL (sendStatusSignal  (QString,QString)),
                 m_xmpp, SLOT   (sendStatus        (QString,QString)));

        // Login with specified user and password
        m_xmpp->login (jid, passwd);
    }
}

void Bridge::playSound (QString name)
{
    // Play specified file from the sounds folder
    QSound::play (QString (":/sounds/sounds/%1.wav").arg (name));
}

void Bridge::shareFiles (const QString& peer)
{
    // Show a QFileDialog and get selected files
    QStringList _filenames =
        QFileDialog::getOpenFileNames (0, tr ("Select files"), QDir::homePath());

    // Send every selected file in a loop
    for (int i = 0; i < _filenames.count(); ++i)
        emit sendFile(_filenames.at (i), peer);
}

void Bridge::sendMessage (const QString& to, const QString &message)
{
    // Send signal to selected chat module
    emit returnPressed (to, message);
}

void Bridge::processNewUser (const QString& nickname, const QString &id,
                             const QImage& profilePicture)
{
    // Register the user name and uid
    m_uuids.append (id);
    m_nicknames.append (nickname);

    // Register the profile picture
    imageProvider->addImage (profilePicture, id);

    // Tell QML interface about new user
    emit newUser (nickname, id);

    // Set status to 'available' in QChat
    if (m_qchat_enabled)
        emit presenceChanged (id, true);
}

void Bridge::copy (const QString &string)
{
    // Clear contents of clipboard
    m_clipboard->clear();

    // Write new contents to clipboard
    m_clipboard->setText (string);
}

QString Bridge::getId (QString nickname)
{
    // Return the ID based on the nickname
    return m_uuids.at (m_nicknames.indexOf (nickname));
}

QString Bridge::downloadPath()
{
    // Save files in SD Card
    if (ANDROID)
        return "/sdcard/Download/";

    // Save files in temporary directory
    else
        return QDir::tempPath() + "/";
}

QString Bridge::manageSmileys (const QString &data)
{
    // Load the smiley "database"
    QFile _file (":/smileys/smileys/data.plist");

    // If we cannot open in, return original string
    if (!_file.open (QFile::ReadOnly))
        return data;

    // Process the original string
    else
        return data;

    // Better be safe than sorry...
    return data;
}

bool Bridge::checkForUpdates()
{
    // Returns 'true' if an update is available
    return m_updater->checkForUpdates();
}

void Bridge::sendStatus (const QString &to, const QString &status)
{
    // Send the status to selected chat module
    emit sendStatusSignal(to, status);
}
