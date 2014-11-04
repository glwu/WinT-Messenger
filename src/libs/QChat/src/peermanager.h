//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  This file is released under the terms of the BSD license.
//

#ifndef NET_PEER_MANAGER_H
#define NET_PEER_MANAGER_H

#include <QList>
#include <QTimer>
#include <QObject>
#include <QtNetwork>
#include <QSettings>
#include <QtNetwork>
#include <QByteArray>
#include <QUdpSocket>
#include <QHostAddress>

#include "client.h"
#include "file-connection/f_connection.h"
#include "message-connection/m_connection.h"

class Client;

class PeerManager : public QObject
{
        Q_OBJECT

    public:

        PeerManager (Client *client);

        void startBroadcasting();
        void setFileServerPort (int port);
        void setMessageServerPort (int port);
        bool isLocalHostAddress (const QHostAddress& address);

        QByteArray nickname;
        QByteArray profile_picture;

    signals:

        void newFileConnection (FConnection *mc);
        void newMessageConnection (MConnection *mc);

    private slots:

        void sendBroadcastDatagram();
        void readBroadcastDatagram();

    private:

        void updateAddresses();

        Client *client;

        int m_serverPort;
        int f_serverPort;

        QTimer broadcastTimer;
        QUdpSocket broadcastSocket;
        QList<QHostAddress> ipAddresses;
        QList<QHostAddress> broadcastAddresses;

        static const qint32 BroadcastInterval = 2000;
        static const unsigned broadcastPort = 45000;
};

#endif
