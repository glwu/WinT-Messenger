//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "bridge.h"

Bridge::Bridge() {
    m_xmpp_enabled = nullptr;
    m_qchat_enabled = nullptr;

    imageProvider = new ImageProvider;
    m_clipboard = QApplication::clipboard();

    m_updater = new Updater();
    connect (m_updater, SIGNAL (updateAvailable (bool, QString)),
             this,      SIGNAL (updateAvailable (bool, QString)));
}

void Bridge::stopLanChat() {
    qDeleteAll (m_qchat_objects.begin(), m_qchat_objects.end());
    m_qchat_objects.clear();
    m_qchat_enabled = false;

    m_uuids.clear();
    m_nicknames.clear();
    imageProvider->clearImages();
}

void Bridge::startLanChat() {
    stopLanChat();
    m_qchat = new QChat();

    if (m_qchat != nullptr) {
        m_qchat_enabled = true;
        m_qchat_objects.append (m_qchat);

        QSettings _settings ("WinT 3794", "WinT Messenger");
        QString _nickname = _settings.value ("nickname", "unknown").toString();
        QImage _profilePicture (":/faces/faces/" +
                                _settings.value ("face", "astronaut.jpg").toString());

        m_qchat->setNickname (_nickname);
        m_qchat->setProfilePicture (_profilePicture);

        m_qchat->setDownloadPath (downloadPath());
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
}

void Bridge::stopXmpp() {
    qDeleteAll (m_xmpp_objects.begin(), m_xmpp_objects.end());
    m_xmpp_objects.clear();
    m_xmpp_enabled = false;

    m_uuids.clear();
    m_nicknames.clear();
    imageProvider->clearImages();
}

void Bridge::startXmpp (QString jid, QString passwd) {
    stopXmpp();
    m_xmpp = new Xmpp();

    if (m_xmpp != nullptr) {
        m_xmpp_enabled = true;
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
}

void Bridge::shareFiles (const QString& peer) {
    QStringList _filenames =
        QFileDialog::getOpenFileNames (0, tr ("Select files"), QDir::homePath());

    for (int i = 0; i < _filenames.count(); ++i)
        emit sendFile (_filenames.at (i), peer);
}

void Bridge::sendMessage (const QString& to, const QString &message) {
    emit returnPressed (to, message);
}

void Bridge::processNewUser (const QString& nickname, const QString &id,
                             const QImage& profilePicture) {
    m_uuids.append (id);
    m_nicknames.append (nickname);
    imageProvider->addImage (profilePicture, id);

    emit newUser (nickname, id);

    if (m_qchat_enabled)
        emit presenceChanged (id, true);
}

void Bridge::copy (const QString &string) {
    m_clipboard->clear();
    m_clipboard->setText (string);
}

QString Bridge::getId (QString nickname) {
    return m_uuids.at (m_nicknames.indexOf (nickname));
}

QString Bridge::downloadPath() {
    if (ANDROID)
        return "/sdcard/Download/";

    else
        return QDir::tempPath() + "/";
}

QString Bridge::manageSmileys (const QString &data) {
    QFile _file (":/smileys/smileys/data.plist");

    if (!_file.open (QFile::ReadOnly))
        return data;

    else
        return data;

    return data;
}

void Bridge::checkForUpdates() {
    m_updater->checkForUpdates();
}

void Bridge::sendStatus (const QString &to, const QString &status) {
    emit sendStatusSignal (to, status);
}
