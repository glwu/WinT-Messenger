#ifndef NET_CLIENT_H
#define NET_CLIENT_H

#include <math.h>

#include <qhash.h>
#include <QtNetwork>
#include <qhostaddress.h>
#include <qabstractsocket.h>

#include "peermanager.h"
#include "file-connection/f_server.h"
#include "message-connection/m_server.h"
#include "file-connection/f_connection.h"
#include "message-connection/m_connection.h"

class PeerManager;

class Client : public QObject {
    Q_OBJECT

public:
    Client();
    PeerManager *peerManager;

    QString nickName() const;
    void sendFile(const QString &path);
    void setUserFace(const QString &face);
    void setNickname(const QString &nick);
    void sendMessage(const QString &message);
    void setDownloadPath(const QString &path);
    bool hasConnection(const QHostAddress &senderIp, int senderPort = -1) const;

signals:
    void participantLeft(const QString &nick);
    void newParticipant(const QString &nick, const QString &face);
    void downloadComplete(const QString &peer_address, const QString &f_name);

    void newMessage(const QString &from, const QString &face,
                    const QString &message);

    void updateProgress(const QString &peer_address, const QString &d_name,
                        int progress);

    void newDownload(const QString &peer_address, const QString &f_name,
                     int f_size);

private slots:
    void readyForUseMsg();
    void disconnectedMsg();
    void connectionErrorMsg(QAbstractSocket::SocketError socketError);

    void readyForUseFile();
    void disconnectedFile();
    void connectionErrorFile(QAbstractSocket::SocketError socketError);

    void newFileConnection(FConnection *fc);
    void newMessageConnection(MConnection *mc);

private:
    MServer m_server;
    FServer f_server;

    QString downloadPath;

    QMultiHash<QHostAddress, FConnection *> file_peers;
    QMultiHash<QHostAddress, MConnection *> message_peers;

    void removeConnectionFile(FConnection *connection);
    void removeConnectionMsg(MConnection *connection);
};

#endif
