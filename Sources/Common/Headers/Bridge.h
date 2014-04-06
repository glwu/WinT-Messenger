//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#ifndef BRIDGE_H
#define BRIDGE_H

#include <QScreen>
#include <QFileDialog>
#include <QMessageBox>
#include <QApplication>

#include "Emotes.h"
#include "../../Chat/Network/Headers/NetChat.h"

#ifdef Q_OS_WIN
#include <qt_windows.h>
#include <qwindowdefs_win.h>
#endif

class Bridge: public QWidget {

    Q_OBJECT

public:
    Bridge();

    Q_INVOKABLE void attachFile();
    Q_INVOKABLE void sendMessage(QString text);

    Q_INVOKABLE int ratio(int input);

    Q_INVOKABLE void startNetChat();
    Q_INVOKABLE void stopNetChat();

    Q_INVOKABLE void startBtChat();
    Q_INVOKABLE void stopBtChat();

    Q_INVOKABLE bool hotspotEnabled();
    Q_INVOKABLE void stopHotspot();
    Q_INVOKABLE void startHotspot(const QString &_ssid, const QString &_password);

private slots:
    void processMessage(const QString &text);

signals:
    void newMessage(const QString &text);
    void returnPressed(const QString &text);
    void newUser(const QString &nick);
    void delUser(const QString &nick);

private:
    NetChat *netChat;
    Emotes *emotes;

    bool netChatEnabled;
    bool netHotspot;
    int emotesSize;
};

#endif
