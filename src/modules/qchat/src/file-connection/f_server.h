#ifndef FILE_SERVER_H
#define FILE_SERVER_H

#include <QtNetwork>
#include <QTcpServer>

#include "f_connection.h"

class FServer : public QTcpServer {
    Q_OBJECT

public:
    FServer(QObject *parent = 0);

signals:
    void newConnection(FConnection* connection);

protected:
    void incomingConnection(qintptr socketDescriptor);
};

#endif
