#ifndef NET_SERVER_H
#define NET_SERVER_H

#include <QtNetwork>
#include <QTcpServer>

#include "connection.h"

class Connection;

/*==============================================================================*
 * What does this class do?                                                     *
 *------------------------------------------------------------------------------*
 * This class is in charge to listen for any incoming connections and emit a    *
 * SIGNAL when a new peer is discovered.                                        *
 *==============================================================================*/

class Server : public QTcpServer
{
    Q_OBJECT

public:
    Server(QObject *parent = 0);

signals:
    void newConnection(Connection *connection);

protected:
    void incomingConnection(qintptr socketDescriptor);
};

#endif
