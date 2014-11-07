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
    // Initialize components
    imageProvider = new ImageProvider;
    m_updater = new QSimpleUpdater();
    m_clipboard = QApplication::clipboard();

    QString _download_url;
    QString _url_base = "https://raw.githubusercontent.com/wint-3794/wint-messenger/updater/files/";

    // Get the download URL based on the OS
#if defined(Q_OS_MAC)
    _download_url = _url_base + "wint-messenger-latest.dmg";
#elif defined(Q_OS_WIN32)
    _download_url = _url_base + "wint-messenger-latest.exe";
#elif defined(Q_OS_ANDROID)
    _download_url = _url_base + "wint-messenger-latest.apk";
#elif defined(Q_OS_LINUX)
    _download_url = _url_base + "wint-messenger-latest.tar.gz";
#endif

    // Configure the application updater
    m_updater->setApplicationVersion ("0.1");
    m_updater->setDownloadUrl  (_download_url);
    m_updater->setReferenceUrl ("https://raw.githubusercontent.com/wint-3794/wint-messenger/updater/latest.txt");
    m_updater->setChangelogUrl ("https://raw.githubusercontent.com/wint-3794/wint-messenger/updater/changelog.txt");

    // Communicate the auto-updater with the QML interface
    connect (m_updater, SIGNAL (checkingFinished()), this, SLOT (onCheckingFinished()));
}

void Bridge::stopLanChat()
{
    // Delete all registered users
    clearUsers();

    // Delete all registered QChat objects
    m_qchat_objects.clear();
}

void Bridge::startLanChat()
{
    stopLanChat();

    // Create and register a new qChat object
    m_qchat = new QChat();
    m_qchat_objects.append (m_qchat);

    // Set the nickname and profile picture
    QSettings _settings ("WinT 3794", "WinT Messenger");
    m_qchat->setNickname (_settings.value ("nickname", "unknown").toString());
    m_qchat->setProfilePicture (QImage (":/faces/faces/" +
                                        _settings.value ("face", "astronaut.jpg").toString()));

    // Set the download path
    m_qchat->setDownloadPath (downloadPath());

    // Receive data from QChat and send it to QML
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

    // Send data from QML to QChat object
    connect (this,    SIGNAL (returnPressed (QString, QString)),
             m_qchat, SLOT   (returnPressed (QString, QString)));
    connect (this,    SIGNAL (sendFile  (QString, QString)),
             m_qchat, SLOT   (shareFile (QString, QString)));
    connect (this,    SIGNAL (sendStatusSignal  (QString, QString)),
             m_qchat, SLOT   (sendStatus        (QString, QString)));
}

void Bridge::stopXmpp()
{
    // Delete all registered users
    clearUsers();

    // Delete all registered Xmpp objects
    m_xmpp_objects.clear();
}

void Bridge::startXmpp (QString jid, QString passwd)
{
    Q_ASSERT(!jid.isEmpty());
    Q_ASSERT(!passwd.isEmpty());

    stopXmpp();

    // Create and register a new Xmpp object
    m_xmpp = new Xmpp();
    m_xmpp_objects.append (m_xmpp);

    // Receive data from Xmpp and send it to QML
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

    // Send data from QML to Xmpp
    connect (this,   SIGNAL (returnPressed (QString, QString)),
             m_xmpp, SLOT   (sendMessage   (QString, QString)));
    connect (this,   SIGNAL (sendFile  (QString, QString)),
             m_xmpp, SLOT   (shareFile (QString, QString)));
    connect (this,   SIGNAL (sendStatusSignal  (QString, QString)),
             m_xmpp, SLOT   (sendStatus        (QString, QString)));

    // Try to login with given information
    m_xmpp->login (jid, passwd);
}

void Bridge::shareFiles (const QString& peer)
{
    Q_ASSERT(!peer.isEmpty());

    // Get list of selected files
    QStringList _filenames =
            QFileDialog::getOpenFileNames (0, tr ("Select files"), QDir::homePath());

    // Send each file using the SIGNALS/SLOTS mechanism
    for (int i = 0; i < _filenames.count(); ++i)
        emit sendFile (_filenames.at (i), peer);
}

void Bridge::sendMessage (const QString& to, const QString &message)
{
    Q_ASSERT(!message.isEmpty());

    // Send data from QML to current chat module
    emit returnPressed (to, message);
}

void Bridge::clearUsers()
{
    // Remove Unique User IDs
    m_uuids.clear();

    // Remove all user nicknames
    m_nicknames.clear();

    // Clear all downloaded profile images
    imageProvider->clearImages();
}

void Bridge::onCheckingFinished()
{
    // Send data from m_updater to QML interface
    emit updateAvailable (m_updater->newerVersionAvailable(), m_updater->latestVersion());
}

void Bridge::processNewUser (const QString& nickname, const QString &id,
                             const QImage& profilePicture)
{
    Q_ASSERT(!id.isEmpty());
    Q_ASSERT(!nickname.isEmpty());

    // Register user ID
    m_uuids.append (id);

    // Register user nickname
    m_nicknames.append (nickname);

    // Register profile picture
    imageProvider->addImage (profilePicture, id);

    // Tell the QML interface about our new guest
    emit newUser (nickname, id);
}

void Bridge::copy (const QString &string)
{
    Q_ASSERT(!string.isEmpty());

    // Overwrite the contents of the system clipboard
    // with the input string
    m_clipboard->clear();
    m_clipboard->setText (string);
}

QString Bridge::getId (QString nickname)
{
    Q_ASSERT(!nickname.isEmpty());

    // Get the ID based on the nickname...we can do this
    // piece of dirty code because the information of
    // an user is registered at the same time and thus,
    // at the same index
    return m_uuids.at (m_nicknames.indexOf (nickname));
}

QString Bridge::downloadPath()
{
#ifdef Q_OS_ANDROID
    // Save all downloaded files of the SD Card under
    // Android OS
    return "/sdcard/Download/";
#else
    // Save all files in a temporary directory under
    // other operating systems
    return QDir::tempPath() + "/";
#endif
}

QString Bridge::manageSmileys (const QString &data)
{
    Q_ASSERT(!data.isEmpty());

    QFile _file (":/smileys/smileys/data.plist");

    if (!_file.open (QFile::ReadOnly))
        return data;

    else
        return data;

    return data;
}

void Bridge::checkForUpdates()
{
    m_updater->checkForUpdates();
}

void Bridge::downloadUpdates()
{
    m_updater->downloadLatestVersion();
}

void Bridge::sendStatus (const QString &to, const QString &status)
{
    Q_ASSERT(!status.isEmpty());

    // Send data from QML to current chat module
    emit sendStatusSignal (to, status);
}
