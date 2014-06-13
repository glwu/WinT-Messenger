//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#ifndef BRIDGE_H
#define BRIDGE_H

#include "chat/chat.h"
#include "device_manager.h"

//============================================================================//
//Why the heck does this class exist?                                         //
//----------------------------------------------------------------------------//
//This class is in charge to communicate the QML interface with the Chat class//
//We communitcate the QML interface with the Chat class directly because the  //
//chat class must be destroyed everytime that the user leaves the chat room.  //
//============================================================================//

class Bridge : public QObject {

    Q_OBJECT

public:
    Bridge();

    Q_INVOKABLE void stopChat();
    Q_INVOKABLE void startChat();
    Q_INVOKABLE QString getDownloadPath();
    Q_INVOKABLE void shareFile(const QString path);
    Q_INVOKABLE void sendMessage(const QString message);

private slots:
    void messageRecieved(const QString &from, const QString &face, const QString &message, bool localUser);

private:
    Chat* chat;
    bool lan_chat;
    DeviceManager manager;
    QList<Chat*> chatObjects;

signals:
    void delUser(const QString &nick);
    void returnPressed(const QString &message);
    void newUser(const QString &nick, const QString &face);
    void drawMessage(const QString &from, const QString &face, const QString &message, bool localUser);
};

#endif
