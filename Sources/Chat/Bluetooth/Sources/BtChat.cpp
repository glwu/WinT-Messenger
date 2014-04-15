//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "../Headers/BtChat.h"

static const QLatin1String serviceUuid("e8e10f95-1a70-4b27-9ccf-02010264e9c8");

BtChat::BtChat(){
    localAdapters = QBluetoothLocalDevice::allDevices();

    if (localAdapters.count() > 2) {
        QBluetoothLocalDevice adapter(localAdapters.at(0).address());
        adapter.setHostMode(QBluetoothLocalDevice::HostDiscoverable);
    }

    server = new BtServer(this);
    connect(server, SIGNAL(clientConnected(QString)),    this, SLOT(newParticipant(QString)));
    connect(server, SIGNAL(clientDisconnected(QString)), this, SLOT(participantLeft(QString)));
    connect(server, SIGNAL(messageReceived(QString)),    this, SIGNAL(insertMessage(QString)));

    QSettings settings("WinT Messenger");
    nickname = settings.value("userName", "unknown").toString();
}

BtChat::~BtChat() {
    qDeleteAll(clients);
    delete server;
}

void BtChat::returnPressed(QString text) {
    emit insertMessage(MessageManager::formatMessage(text, nickname));
    emit sendMessage(MessageManager::formatMessage(text, nickname));
    server->sendMessage(MessageManager::formatMessage(text, nickname));
}

void BtChat::shareFile() {
}

void BtChat::showBtSelector() {
    const QBluetoothAddress adapter = QBluetoothAddress();
    BtSelector remoteSelector(adapter);

    remoteSelector.startDiscovery(QBluetoothUuid(serviceUuid));

    if (remoteSelector.exec() == QDialog::Accepted) {
        QBluetoothServiceInfo service = remoteSelector.service();

        BtClient *client = new BtClient(this);
        connect(client, SIGNAL(messageReceived(QString)), this,   SIGNAL(insertMessage(QString)));
        connect(client, SIGNAL(disconnected()),           this,   SLOT(removeClients()));
        connect(client, SIGNAL(connected(QString)),       this,   SLOT(clientConnected(QString)));
        connect(this,   SIGNAL(sendMessage(QString)),     client, SLOT(sendMessage(QString)));

        client->startClient(service);
        clients.append(client);
    }
}

void BtChat::newParticipant(const QString &nick) {
    emit insertMessage(MessageManager::formatNotification("%1 has joined").arg(nick));
}

void BtChat::participantLeft(const QString &nick) {
    emit insertMessage(MessageManager::formatNotification("%1 has left").arg(nick));
}

void BtChat::removeClients() {
    BtClient *client = qobject_cast<BtClient *>(sender());
    if (client) {
        clients.removeOne(client);
        client->deleteLater();
    }
}

void BtChat::clientConnected(const QString &client) {
    emit insertMessage(MessageManager::formatNotification("Joined chat with %1").arg(client));
}
