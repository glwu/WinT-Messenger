#ifndef NET_SERVER_H
#define NET_SERVER_H

#include <QtNetwork>
#include <QTcpServer>

class NetConnection;

class NetServer : public QTcpServer
{
    Q_OBJECT

public:
    NetServer(QObject *parent = 0);

signals:
    void newConnection(NetConnection *connection);

protected:
    void incomingConnection(qintptr socketDescriptor);
};

#endif
