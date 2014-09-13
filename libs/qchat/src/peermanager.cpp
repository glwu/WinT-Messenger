//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  This file is released under the terms of the BSD license.
//

#include "peermanager.h"

PeerManager::PeerManager (Client *client) : QObject (client)
{
    this->client = client;
    updateAddresses();
    f_serverPort = 0;
    m_serverPort = 0;
    broadcastSocket.bind (QHostAddress::Any,
                          broadcastPort,
                          QUdpSocket::ShareAddress | QUdpSocket::ReuseAddressHint);
    broadcastTimer.setInterval (BroadcastInterval);
    connect (&broadcastSocket,
             SIGNAL (readyRead()),
             this,
             SLOT (readBroadcastDatagram()));
    connect (
        &broadcastTimer, SIGNAL (timeout()), this, SLOT (sendBroadcastDatagram()));
}

void PeerManager::setFileServerPort (int port)
{
    f_serverPort = port;
}

void PeerManager::setMessageServerPort (int port)
{
    m_serverPort = port;
}

void PeerManager::startBroadcasting()
{
    broadcastTimer.start();
}

bool PeerManager::isLocalHostAddress (const QHostAddress& address)
{
    foreach (QHostAddress localAddress, ipAddresses)

    if (address == localAddress)
        return true;

    return false;
}

void PeerManager::sendBroadcastDatagram()
{
    QByteArray datagram (nickname);
    datagram.append ('@');
    datagram.append (QByteArray::number (f_serverPort));
    datagram.append ('@');
    datagram.append (QByteArray::number (m_serverPort));
    bool validBroadcastAddresses = true;
    foreach (QHostAddress address, broadcastAddresses)

    if (broadcastSocket.writeDatagram (datagram, address, broadcastPort) == -1)
        validBroadcastAddresses = false;

    if (!validBroadcastAddresses)
        updateAddresses();
}

void PeerManager::readBroadcastDatagram()
{
    while (broadcastSocket.hasPendingDatagrams())
    {
        QHostAddress senderIp;
        quint16 senderPort;
        QByteArray datagram;
        datagram.resize (broadcastSocket.pendingDatagramSize());

        if (broadcastSocket.readDatagram (
                    datagram.data(), datagram.size(), &senderIp, &senderPort) == -1)
            continue;

        QList<QByteArray> list = datagram.split ('@');

        if (list.size() != 3)
            continue;

        int senderFilePort = list.at (1).toInt();
        int senderMessagePort = list.at (2).toInt();

        if (isLocalHostAddress (senderIp) && senderMessagePort == m_serverPort &&
                senderFilePort == f_serverPort)
            continue;

        if (!client->hasConnection (senderIp))
        {
            FConnection *fc = new FConnection (this);
            MConnection *mc = new MConnection (this);
            fc->connectToHost (senderIp, senderFilePort);
            mc->connectToHost (senderIp, senderMessagePort);
            emit newFileConnection (fc);
            emit newMessageConnection (mc);
        }
    }
}

void PeerManager::updateAddresses()
{
    broadcastAddresses.clear();
    ipAddresses.clear();
    foreach (QNetworkInterface interface, QNetworkInterface::allInterfaces())
    {
        foreach (QNetworkAddressEntry entry, interface.addressEntries())
        {
            QHostAddress broadcastAddress = entry.broadcast();

            if (broadcastAddress != QHostAddress::Null &&
                    entry.ip() != QHostAddress::LocalHost)
            {
                broadcastAddresses << broadcastAddress;
                ipAddresses << entry.ip();
            }
        }
    }
}
