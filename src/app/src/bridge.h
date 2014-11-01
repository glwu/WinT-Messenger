//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef BRIDGE_H
#define BRIDGE_H

#include <QImage>
#include <QClipboard>
#include <QFileDialog>
#include <QDomDocument>

#include <Xmpp>
#include <QChat>

#include "updater.h"
#include "platforms.h"
#include "image_provider.h"
#include "device_manager.h"

class Bridge : public QObject {
    Q_OBJECT

  public:

    Bridge();

    /// Stops and deletes the current instances
    /// of the qChat module
    Q_INVOKABLE void stopLanChat();

    /// Starts and configures a new instance of
    /// the qChat module
    Q_INVOKABLE void startLanChat();

    /// Stops and deletes the current instances
    /// of the XMPP module
    Q_INVOKABLE void stopXmpp();

    /// Starts and configures a new instance of
    /// the XMPP module with the given JID and password
    Q_INVOKABLE void startXmpp (QString jid, QString passwd);

    /// Returns the fullname of an user given its ID
    Q_INVOKABLE QString getId (QString nickname);

    /// Shares a selection of files to the given user
    Q_INVOKABLE void shareFiles (const QString& peer);

    /// Returns a smiley code or a HTML image based on the
    /// input string
    Q_INVOKABLE QString manageSmileys (const QString &data);

    /// Sends a status message to given peer
    Q_INVOKABLE void sendStatus (const QString &to, const QString &status);

    /// Sends a message to the given peer
    Q_INVOKABLE void sendMessage (const QString& to, const QString &message);

    /// Returns the path where WinT Messenger should write downloaded files
    Q_INVOKABLE QString downloadPath();

    /// Requests the \c Updater class to check for a newer version of the application
    Q_INVOKABLE void checkForUpdates();

    /// Copies the given string to the system's clipboard (the JS implementation
    /// was too complicated for our needs)
    Q_INVOKABLE void copy (const QString &string);

    DeviceManager manager;
    ImageProvider *imageProvider;

  signals:

    void xmppConnected();
    void xmppDisconnected();
    void delUser (QString nick, QString id);
    void newUser (QString nick, QString id);
    void sendFile (QString file, QString peer);
    void drawMessage (QString from, QString message);
    void sendStatusSignal (QString to, QString status);
    void returnPressed (QString message, QString peer);
    void downloadComplete (QString name, QString file);
    void newDownload (QString name, QString file, int size);
    void presenceChanged (const QString &id, bool connected);
    void updateAvailable (bool newUpdate, const QString &version);
    void updateProgress (QString name, QString file, int progress);
    void statusChanged (const QString &from, const QString &status);

  private slots:

    void processNewUser (const QString& nickname, const QString& id, const QImage& profilePicture);

  private:

    Xmpp *m_xmpp;
    QChat *m_qchat;
    Updater *m_updater;

    QStringList m_uuids;
    QStringList m_nicknames;

    QClipboard *m_clipboard;

    bool m_xmpp_enabled;
    bool m_qchat_enabled;

    QList<Xmpp *> m_xmpp_objects;
    QList<QChat *> m_qchat_objects;
};

#endif
