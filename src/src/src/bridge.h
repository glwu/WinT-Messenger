//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef BRIDGE_H
#define BRIDGE_H

#include <qsound.h>
#include <qfiledialog.h>

#include "qchat.h"
#include "xmpp_chat.h"
#include "device_manager.h"

#if defined(Q_OS_IOS)
#define SSL_SUPPORT false
#else
#define SSL_SUPPORT true
#include "updater.h"
#endif

class Bridge : public QObject {
    Q_OBJECT

public:
    Bridge();

    // qChat functions
    Q_INVOKABLE void stopLanChat();
    Q_INVOKABLE void startLanChat();

    // xmppChat functions
    Q_INVOKABLE void stopXmppChat();
    Q_INVOKABLE bool startXmppChat(QString jid, QString passwd);

    // Common chat functions
    Q_INVOKABLE void playSound();
    Q_INVOKABLE void shareFiles();
    Q_INVOKABLE void saveChat(QString chat);
    Q_INVOKABLE void sendMessage(QString message);

    // Other functions
    Q_INVOKABLE bool checkForUpdates();
    Q_INVOKABLE QString getDownloadPath();

    DeviceManager manager;

private slots:
    // Process message
    void messageReceived(QString from, QString face, QString message,
                         QString color, char localUser);

private:
    // QChat functions
    QChat* qchat;
    bool qchat_enabled;
    QList<QChat*> qChatObjects;

    // XMPP chat functions
    XmppChat* xmppChat;
    bool xmppchat_enabled;
    QList<XmppChat*> xmppChatObjects;

    QSound *sound;

#ifndef Q_OS_IOS
    Updater* updater;
#endif

signals:
    void updateAvailable();
    void delUser(QString nick);
    void returnPressed(QString message);
    void newUser(QString nick, QString face);
    void downloadComplete(QString peer_address, QString d_name);
    void updateProgress(QString peer_address, QString d_name, int progress);
    void newDownload(QString peer_address, QString f_name, int f_size);
    void drawMessage(QString from, QString face, QString message, QString color, bool localUser);
};

#endif
