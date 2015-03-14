//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  Please check the license.txt file for more information.
//

#include "bridge.h"

Bridge::Bridge()
{
    imageProvider = new ImageProvider;
    m_updater = new QSimpleUpdater();
    m_clipboard = QApplication::clipboard();

    QString _download_url;
    QString _url_base = "https://raw.githubusercontent.com/wint-3794/wint-messenger/updater/files/";

#if defined(Q_OS_MAC)
    _download_url = _url_base + "wint-messenger-latest.dmg";
#elif defined(Q_OS_WIN32)
    _download_url = _url_base + "wint-messenger-latest.exe";
#elif defined(Q_OS_ANDROID)
    _download_url = _url_base + "wint-messenger-latest.apk";
#elif defined(Q_OS_LINUX)
    _download_url = _url_base + "wint-messenger-latest.tar.gz";
#endif

    m_updater->setApplicationVersion (APP_VERSION);
    m_updater->setDownloadUrl  (_download_url);
    m_updater->setReferenceUrl ("https://raw.githubusercontent.com/wint-3794/wint-messenger/updater/latest.txt");
    m_updater->setChangelogUrl ("https://raw.githubusercontent.com/wint-3794/wint-messenger/updater/changelog.txt");

    connect (m_updater, SIGNAL (checkingFinished()), this, SLOT (onCheckingFinished()));
}

void Bridge::stopLanChat()
{
    clearUsers();
	
	qDeleteAll (m_qchat_objects.begin(), m_qchat_objects.end());
    m_qchat_objects.clear();
}

void Bridge::startLanChat()
{
    m_qchat = new QChat();
    m_qchat_objects.append (m_qchat);

    // Set the nickname and profile picture
    QSettings _settings ("WinT 3794", "WinT Messenger");
    m_qchat->setNickname (_settings.value ("nickname", "unknown").toString());
    m_qchat->setProfilePicture (QImage (":/faces/faces/" +
                                        _settings.value ("face", "astronaut.jpg").toString()));

    m_qchat->setDownloadPath (downloadPath());

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
    connect (this,    SIGNAL (sendFile  (QString, QString)),
             m_qchat, SLOT   (shareFile (QString, QString)));
    connect (this,    SIGNAL (sendStatusSignal  (QString, QString)),
             m_qchat, SLOT   (sendStatus        (QString, QString)));
}

void Bridge::stopXmpp()
{
    clearUsers();
	
	qDeleteAll (m_xmpp_objects.begin(), m_xmpp_objects.end());
    m_xmpp_objects.clear();
}

void Bridge::startXmpp (QString jid, QString passwd)
{
    Q_ASSERT (!jid.isEmpty());
    Q_ASSERT (!passwd.isEmpty());

    m_xmpp = new Xmpp();
    m_xmpp_objects.append (m_xmpp);

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
    connect (this,   SIGNAL (sendFile  (QString, QString)),
             m_xmpp, SLOT   (shareFile (QString, QString)));
    connect (this,   SIGNAL (sendStatusSignal  (QString, QString)),
             m_xmpp, SLOT   (sendStatus        (QString, QString)));

    m_xmpp->login (jid, passwd);
}

void Bridge::shareFiles (const QString& peer)
{
    Q_ASSERT (!peer.isEmpty());

    // Get list of selected files
    QStringList _filenames =
        QFileDialog::getOpenFileNames (0, tr ("Select files"), QDir::homePath());

    // Send each file using the SIGNALS/SLOTS mechanism
    for (int i = 0; i < _filenames.count(); ++i)
        emit sendFile (_filenames.at (i), peer);
}

void Bridge::sendMessage (const QString& to, const QString &message)
{
    Q_ASSERT (!message.isEmpty());
    emit returnPressed (to, message);
}

void Bridge::clearUsers()
{
    m_uuids.clear();
    m_nicknames.clear();
    imageProvider->clearImages();
}

void Bridge::onCheckingFinished()
{
    emit updateAvailable (m_updater->newerVersionAvailable(), m_updater->latestVersion());
}

void Bridge::processNewUser (const QString& nickname, const QString &id,
                             const QImage& profilePicture)
{
    Q_ASSERT (!id.isEmpty());
    Q_ASSERT (!nickname.isEmpty());

    m_uuids.append (id);
    m_nicknames.append (nickname);
    imageProvider->addImage (profilePicture, id);

    emit newUser (nickname, id);
}

void Bridge::copy (const QString &string)
{
    Q_ASSERT (!string.isEmpty());

    m_clipboard->clear();
    m_clipboard->setText (string);
}

QString Bridge::getId (QString nickname)
{
    Q_ASSERT (!nickname.isEmpty());
    return m_uuids.at (m_nicknames.indexOf (nickname));
}

QString Bridge::downloadPath()
{
#ifdef Q_OS_ANDROID
    return "/sdcard/Download/";
#else
    return QDir::tempPath() + "/";
#endif
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
    Q_ASSERT (!status.isEmpty());
    emit sendStatusSignal (to, status);
}
