/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
** Redistributions of source code must retain the above copyright
** notice, this list of conditions and the following disclaimer.
** Redistributions in binary form must reproduce the above copyright
** notice, this list of conditions and the following disclaimer in
** the documentation and/or other materials provided with the
** distribution.
** Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
** of its contributors may be used to endorse or promote products derived
** from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "peermanager.h"

/*!
 * \brief PeerManager::PeerManager
 * \param client
 *
 * Initializes the \c PeerManager and assigns the default values to:
 *  - username
 *  - userface
 *  - f_serverPort
 *  - m_serverPort
 *
 * Finally, the function connects SINGALS and SLOTS to allow us to read and send
 * broadcast datagrams.
 */

PeerManager::PeerManager(Client *client) : QObject(client) {
    this->client = client;

    QSettings settings("WinT 3794", "WinT Messenger");

    username = settings.value("userName", "unknown").toByteArray();
    if (username.isEmpty())
        username = "unknown";

    userface = settings.value("face", "astronaut.jpg").toByteArray();

    updateAddresses();
    f_serverPort = 0;
    m_serverPort = 0;

    broadcastSocket.bind(QHostAddress::Any, broadcastPort, QUdpSocket::ShareAddress | QUdpSocket::ReuseAddressHint);
    connect(&broadcastSocket, SIGNAL(readyRead()), this, SLOT(readBroadcastDatagram()));

    broadcastTimer.setInterval(BroadcastInterval);
    connect(&broadcastTimer, SIGNAL(timeout()), this, SLOT(sendBroadcastDatagram()));
}

/*!
 * \brief PeerManager::setFileServerPort
 * \param port
 *
 * Changes the value of /c f_serverPort based on the
 * /c port parameter.
 */

void PeerManager::setFileServerPort(int port) {
    f_serverPort = port;
}

/*!
 * \brief PeerManager::setMessageServerPort
 * \param port
 *
 * Changes the value of /c m_serverPort based on the
 * /c port parameter.
 */

void PeerManager::setMessageServerPort(int port) {
    m_serverPort = port;
}

/*!
 * \brief PeerManager::userName
 * \return
 *
 * Returns the value of /c username.
 */

QByteArray PeerManager::userName() const {
    return username;
}

/*!
 * \brief PeerManager::face
 * \return
 *
 * Returns the value of /c userface.
 */

QByteArray PeerManager::face() const {
    return userface;
}

/*!
 * \brief PeerManager::startBroadcasting
 *
 * Starts the /c broadcastTimer, thus allowing the program
 * to send broadcast datagrams.
 */

void PeerManager::startBroadcasting() {
    broadcastTimer.start();
}

/*!
 * \brief PeerManager::isLocalHostAddress
 * \param address
 * \return
 *
 * Returns /c true if /c address is from local computer (localhost).
 */

bool PeerManager::isLocalHostAddress(const QHostAddress &address) {
    foreach (QHostAddress localAddress, ipAddresses)
        if (address == localAddress)
            return true;

    return false;
}

/*!
 * \brief PeerManager::sendBroadcastDatagram
 *
 * Sends a byte array to all addresses with the following data:
 *  - username
 *  - f_serverPort
 *  - m_serverPort
 */

void PeerManager::sendBroadcastDatagram() {
    QByteArray datagram(username);
    datagram.append('@');
    datagram.append(QByteArray::number(f_serverPort));
    datagram.append('@');
    datagram.append(QByteArray::number(m_serverPort));

    bool validBroadcastAddresses = true;
    foreach (QHostAddress address, broadcastAddresses)
        if (broadcastSocket.writeDatagram(datagram, address, broadcastPort) == -1)
            validBroadcastAddresses = false;

    if (!validBroadcastAddresses)
        updateAddresses();
}

/*!
 * \brief PeerManager::readBroadcastDatagram
 *
 * Reads a broadcast datagram, extracts the IP of the sender and
 * its /c FServer and /c MServer ports. Then the function tries to
 * establish a connection with the sender of the datagram.
 */

void PeerManager::readBroadcastDatagram() {
    while (broadcastSocket.hasPendingDatagrams()) {
        QHostAddress senderIp;
        quint16 senderPort;
        QByteArray datagram;
        datagram.resize(broadcastSocket.pendingDatagramSize());
        if (broadcastSocket.readDatagram(datagram.data(), datagram.size(),
                                         &senderIp, &senderPort) == -1)
            continue;

        QList<QByteArray> list = datagram.split('@');

        if (list.size() != 3)
            continue;

        int senderFilePort = list.at(1).toInt();
        int senderMessagePort = list.at(2).toInt();

        if (isLocalHostAddress(senderIp) && senderMessagePort == m_serverPort && senderFilePort == f_serverPort)
            continue;

        if (!client->hasConnection(senderIp)) {
            FConnection *fc = new FConnection(this);
            MConnection *mc = new MConnection(this);

            fc->connectToHost(senderIp, senderFilePort);
            mc->connectToHost(senderIp, senderMessagePort);

            emit newFileConnection(fc);
            emit newMessageConnection(mc);
        }
    }
}

/*!
 * \brief PeerManager::updateAddresses
 */

void PeerManager::updateAddresses() {
    broadcastAddresses.clear();
    ipAddresses.clear();
    foreach (QNetworkInterface interface, QNetworkInterface::allInterfaces()) {
        foreach (QNetworkAddressEntry entry, interface.addressEntries()) {
            QHostAddress broadcastAddress = entry.broadcast();
            if (broadcastAddress != QHostAddress::Null && entry.ip() != QHostAddress::LocalHost) {
                broadcastAddresses << broadcastAddress;
                ipAddresses << entry.ip();
            }
        }
    }
}
