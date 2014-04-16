#ifndef NET_CLIENT_H
#define NET_CLIENT_H

#include <QHash>
#include <QtNetwork>
#include <QHostAddress>
#include <QAbstractSocket>

#include "NetServer.h"
#include "NetConnection.h"
#include "NetPeerManager.h"

class NetPeerManager;

class NetClient : public QObject
{
  Q_OBJECT

public:
  NetClient();
  NetPeerManager *peerManager;

  void sendMessage(const QString &message);
  QString nickName() const;
  bool hasConnection(const QHostAddress &senderIp, int senderPort = -1) const;

  int userCount;

signals:
  void newMessage(const QString &message);
  void newParticipant(const QString &nick);
  void participantLeft(const QString &nick);

private slots:
  void newConnection(NetConnection *connection);
  void connectionError(QAbstractSocket::SocketError socketError);
  void disconnected();
  void readyForUse();

private:
  void removeConnection(NetConnection *connection);

  NetServer server;
  QMultiHash<QHostAddress, NetConnection *> peers;
};

#endif
