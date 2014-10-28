//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef MESSAGE_SERVER_H
#define MESSAGE_SERVER_H

#include <QtNetwork>
#include <QTcpServer>

#include "m_connection.h"

class MServer : public QTcpServer {
    Q_OBJECT

  public:

    MServer (QObject *parent = 0);

  signals:

    void newConnection (MConnection *connection);

  protected:

    void incomingConnection (qintptr socketDescriptor);
};

#endif
