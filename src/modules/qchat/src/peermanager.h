#ifndef NET_PEER_MANAGER_H
#define NET_PEER_MANAGER_H

#include <QtNetwork>

#include <qlist.h>
#include <qtimer.h>
#include <qobject.h>
#include <qsettings.h>
#include <qbytearray.h>
#include <qudpsocket.h>
#include <qhostaddress.h>

#include "client.h"
#include "file-connection/f_connection.h"
#include "message-connection/m_connection.h"

class Client;

class PeerManager : public QObject {
    Q_OBJECT

public:
    PeerManager(Client *client);

    QByteArray face() const;
    void startBroadcasting();
    //QByteArray username() const;

    void setFileServerPort(int port);
    void setMessageServerPort(int port);
    bool isLocalHostAddress(const QHostAddress &address);

    QByteArray username;
    QByteArray userface;

signals:
    void newFileConnection(FConnection *mc);
    void newMessageConnection(MConnection *mc);

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
