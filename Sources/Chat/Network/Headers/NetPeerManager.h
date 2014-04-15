#ifndef NET_PEER_MANAGER_H
#define NET_PEER_MANAGER_H

#include <QList>
#include <QTimer>
#include <QObject>
#include <QtNetwork>
#include <QSettings>
#include <QByteArray>
#include <QUdpSocket>
#include <QHostAddress>

#include "NetClient.h"
#include "NetConnection.h"

class NetClient;
class NetConnection;

class NetPeerManager : public QObject
{
    Q_OBJECT

public:
    NetPeerManager(NetClient *client);

    void setServerPort(int port);
    QByteArray userName() const;
    void startBroadcasting();
    bool isLocalHostAddress(const QHostAddress &address);

signals:
    void newConnection(NetConnection *connection);

private slots:
    void sendBroadcastDatagram();
    void readBroadcastDatagram();

private:
    void updateAddresses();

    NetClient *client;
    QList<QHostAddress> broadcastAddresses;
    QList<QHostAddress> ipAddresses;
    QUdpSocket broadcastSocket;
    QTimer broadcastTimer;
    QByteArray username;
    int serverPort;
};

#endif
