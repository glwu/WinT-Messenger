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

#include <QSound>
#include <QFileDialog>

#include "chat/chat.h"
#include "device_manager.h"

#if defined(Q_OS_IOS)
#define SSL_SUPPORT false
#pragma message("Updater engine disabled because target does not support SSL")
#else
#define SSL_SUPPORT true
#include "updater.h"
#endif

class Bridge : public QObject {

    Q_OBJECT

public:
    Bridge();

    Q_INVOKABLE void stopChat();
    Q_INVOKABLE void startChat();
    Q_INVOKABLE void playSound();
    Q_INVOKABLE void shareFiles();
    Q_INVOKABLE bool checkForUpdates();
    Q_INVOKABLE QString getDownloadPath();
    Q_INVOKABLE void saveChat(const QString chat);
    Q_INVOKABLE void sendMessage(const QString message);

    DeviceManager manager;

private slots:
    void messagereceived(const QString &from, const QString &face, const QString &message, char localUser);

private:
    Chat* chat;
    bool lan_chat;
    QList<Chat*> chatObjects;
    QSound *sound;

#ifndef Q_OS_IOS
    Updater* updater;
#endif

signals:
    void updateAvailable();
    void delUser(const QString &nick);
    void returnPressed(const QString &message);
    void newUser(const QString &nick, const QString &face);
    void downloadComplete(const QString &peer_address, const QString &d_name);
    void updateProgress(const QString &peer_address, const QString &d_name, int progress);
    void newDownload(const QString &peer_address, const QString &f_name, const int &f_size);
    void drawMessage(QString from, QString face, QString message, QString color, bool localUser);
};

#endif
