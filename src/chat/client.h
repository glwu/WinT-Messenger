#ifndef NET_CLIENT_H
#define NET_CLIENT_H

#include <math.h>

#include <QHash>
#include <QtNetwork>
#include <QHostAddress>
#include <QAbstractSocket>

#include "peermanager.h"
#include "file-connection/f_server.h"
#include "message-connection/m_server.h"
#include "file-connection/f_connection.h"
#include "message-connection/m_connection.h"

class PeerManager;

class Client : public QObject
{
    Q_OBJECT

public:
    Client();
    PeerManager *peerManager;

    QString nickName() const;
    void sendFile(const QString &path);
    void sendMessage(const QString &message);
    bool hasConnection(const QHostAddress &senderIp, int senderPort = -1) const;

signals:
    void participantLeft(const QString &nick);
    void newFile(const QByteArray &data, const QString &name);
    void newParticipant(const QString &nick, const QString &face);
    void newMessage(const QString &from, const QString &face, const QString &message);

private slots:
    void readyForUseMsg();
    void disconnectedMsg();
    void connectionErrorMsg(QAbstractSocket::SocketError socketError);

    void readyForUseFile();
    void disconnectedFile();
    void connectionErrorFile(QAbstractSocket::SocketError socketError);

    void newFileConnection(FConnection *fc);
    void newMessageConnection(MConnection *mc);
    void getFile(const QByteArray &fileData, const QString &fileName);

private:
    MServer m_server;
    FServer f_server;

    QMultiHash<QHostAddress, FConnection *> file_peers;
    QMultiHash<QHostAddress, MConnection *> message_peers;

    void removeConnectionFile(FConnection *connection);
    void removeConnectionMsg(MConnection *connection);
};

#endif
