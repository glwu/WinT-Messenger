#ifndef NET_CLIENT_H
#define NET_CLIENT_H

#include <QHash>
#include <QtNetwork>
#include <QHostAddress>
#include <QAbstractSocket>

#include "server.h"
#include "connection.h"
#include "peerManager.h"

class PeerManager;

//============================================================================//
//Why the heck does this class exist?                                         //
//----------------------------------------------------------------------------//
//This class is in charge of managing new and existing connections.           //
//For example, when this class is instructed to send a message, it prepares   //
//the message and uses a loop to send it to all connected peers. Also, this   //
//class notifies the Chat class when an user enters or leaves the room.       //
//============================================================================//

class Client : public QObject
{
    Q_OBJECT

public:
    Client();
    PeerManager *peerManager;

    QString nickName() const;
    void sendFile(const QString &fileName);
    void sendMessage(const QString &message);
    bool hasConnection(const QHostAddress &senderIp, int senderPort = -1) const;

signals:
    void participantLeft(const QString &nick);
    void newFile(const QByteArray &data, const QString &name);
    void newParticipant(const QString &nick, const QString &face);
    void newMessage(const QString &from, const QString &face, const QString &message);

private slots:
    void readyForUse();
    void disconnected();
    void newConnection(Connection *connection);
    void connectionError(QAbstractSocket::SocketError socketError);
    void getFile(const QByteArray &fileData, const QString &fileName);

private:
    Server server;
    QMultiHash<QHostAddress, Connection *> peers;
    void removeConnection(Connection *connection);
};

#endif
