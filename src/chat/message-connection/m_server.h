#ifndef MESSAGE_SERVER_H
#define MESSAGE_SERVER_H

#include <QtNetwork>
#include <QTcpServer>

#include "m_connection.h"

class MServer : public QTcpServer
{
    Q_OBJECT

public:
    MServer(QObject *parent = 0);

signals:
    void newConnection(MConnection *connection);

protected:
    void incomingConnection(qintptr socketDescriptor);
};

#endif
