//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef FILE_SERVER_H
#define FILE_SERVER_H

#include <QtNetwork>
#include <QTcpServer>

#include "f_connection.h"

class FServer : public QTcpServer
{
        Q_OBJECT

    public:
        FServer (QObject *parent = 0);

    signals:
        void newConnection (FConnection *connection);

    protected:
        void incomingConnection (qintptr socketDescriptor);
};

#endif
