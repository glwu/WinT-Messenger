//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "bridge.h"

Bridge::Bridge()
{
    m_qchat_enabled = false;
    m_xmpp_enabled = false;
    imageProvider = new ImageProvider;
    m_clipboard = QApplication::clipboard();

    m_updater = new Updater();
    connect (m_updater, SIGNAL (updateAvailable()),
             this,      SIGNAL (updateAvailable()));
}

void Bridge::stopLanChat()
{
    qDeleteAll (m_qchat_objects.begin(), m_qchat_objects.end());
    m_qchat_objects.clear();
    m_qchat_enabled = false;
    imageProvider->clearImages();

    m_uuids.clear();
    m_nicknames.clear();
}

void Bridge::startLanChat()
{
    stopLanChat();
    m_qchat = new QChat();
    m_qchat_objects.append (m_qchat);

    if (m_qchat != NULL)
        m_qchat_enabled = true;

    QSettings _settings ("WinT 3794", "WinT Messenger");
    QString _nickname = _settings.value ("nickname", "unknown").toString();
    QImage _profilePicture (":/faces/faces/" +
                            _settings.value ("face", "astronaut.jpg").toString());

    m_qchat->setNickname (_nickname);
    m_qchat->setDownloadPath (downloadPath());
    m_qchat->setProfilePicture (_profilePicture);
    imageProvider->addImage (_profilePicture, _nickname);

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
    connect (m_qchat, SIGNAL (newMessage (QString, QString)),
             this,    SIGNAL (drawMessage (QString, QString)));
    connect (this,    SIGNAL (returnPressed (QString, QString)),
             m_qchat, SLOT   (returnPressed (QString, QString)));
}

void Bridge::stopXmpp()
{
    qDeleteAll (m_xmpp_objects.begin(), m_xmpp_objects.end());
    m_xmpp_objects.clear();
    m_xmpp_enabled = false;
    imageProvider->clearImages();

    m_uuids.clear();
    m_nicknames.clear();
}

void Bridge::startXmpp (QString jid, QString passwd)
{
    stopXmpp();

    m_xmpp = new Xmpp();
    m_xmpp_objects.append (m_xmpp);

    if (jid.contains ("@facebook.com") || jid.contains ("@fb.com") || jid.contains ("@chat.fb.com"))
    {
        jid.replace ("fb.com", "facebook.com");
        jid.replace ("@facebook.com", "@chat.facebook.com");
    }

    connect (m_xmpp, SIGNAL (connected()),
             this,   SIGNAL (xmppConnected()));
    connect (m_xmpp, SIGNAL (disconnected()),
             this,   SIGNAL (xmppDisconnected()));
    connect (m_xmpp, SIGNAL (delUser (QString, QString)),
             this,   SIGNAL (delUser (QString, QString)));
    connect (m_xmpp, SIGNAL (newMessage (QString, QString)),
             this,   SIGNAL (drawMessage (QString, QString)));
    connect (m_xmpp, SIGNAL (newUser (QString, QString, QImage)),
             this,   SLOT   (processNewUser (QString, QString, QImage)));
    connect (this,   SIGNAL (returnPressed (QString, QString)),
             m_xmpp, SLOT   (sendMessage (QString, QString)));

    m_xmpp->login (jid, passwd);
}

void Bridge::playSound (QString name)
{
    QSound::play (QString (":/sounds/sounds/%1.wav").arg (name));
}

void Bridge::shareFiles (const QString& peer)
{
    QStringList _filenames =
        QFileDialog::getOpenFileNames (0, tr ("Select files"), QDir::homePath());

    if (m_qchat_enabled)
    {
        for (int i = 0; i < _filenames.count(); ++i)
            if (!_filenames.at (i).isEmpty())
                m_qchat->shareFile (_filenames.at (i), peer);
    }

    else if (m_xmpp_enabled)
    {
        for (int i = 0; i < _filenames.count(); ++i)
            if (!_filenames.at (i).isEmpty())
                m_xmpp->shareFile (_filenames.at (i), peer);
    }
}

void Bridge::sendMessage (const QString& to, const QString &message)
{
    emit returnPressed (to, message);
}

void Bridge::processNewUser (const QString& nickname, const QString &id,
                             const QImage& profilePicture)
{
    m_uuids.append (id);
    m_nicknames.append (nickname);

    imageProvider->addImage (profilePicture, id);
    emit newUser (nickname, id);
}

void Bridge::copy(const QString &string) {
    m_clipboard->clear();
    m_clipboard->setText(string);
}

QString Bridge::getId (QString nickname)
{
    return m_uuids.at (m_nicknames.indexOf (nickname));
}

QString Bridge::downloadPath()
{
    if (ANDROID)
        return "/sdcard/Download/";

    else
        return QDir::tempPath() + "/";
}

QString Bridge::manageSmileys (const QString &data)
{
    QFile _file (":/smileys/smileys/data.plist");

    if (!_file.open (QFile::ReadOnly))
        return data;

    return data;
}

bool Bridge::checkForUpdates()
{
    return m_updater->checkForUpdates();
}
