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

#include "client.h"
#include "connection.h"

class Client;
class Connection;

//============================================================================//
//Why the heck does this class exist?                                         //
//----------------------------------------------------------------------------//
//This class is in charge of discoverying new peers and establishing a        //
//connection with them and notify the Client class when a peer enters/leaves  //
//the chat room.                                                              //
//============================================================================//

class PeerManager : public QObject
{
    Q_OBJECT

public:
    PeerManager(Client *client);

    QByteArray face() const;
    void startBroadcasting();
    QByteArray userName() const;
    void setServerPort(int port);
    bool isLocalHostAddress(const QHostAddress &address);

signals:
    void newConnection(Connection *connection);

private slots:
    void sendBroadcastDatagram();
    void readBroadcastDatagram();

private:
    void updateAddresses();

    Client *client;
    int serverPort;
    QByteArray username;
    QByteArray userface;
    QTimer broadcastTimer;
    QUdpSocket broadcastSocket;
    QList<QHostAddress> ipAddresses;
    QList<QHostAddress> broadcastAddresses;
};

#endif
