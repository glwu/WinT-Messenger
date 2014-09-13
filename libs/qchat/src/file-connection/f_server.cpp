//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "f_server.h"

FServer::FServer (QObject *parent) : QTcpServer (parent)
{
    listen (QHostAddress::Any);
}

void FServer::incomingConnection (qintptr socketDescriptor)
{
    FConnection *file_connection = new FConnection (this);
    file_connection->setSocketDescriptor (socketDescriptor);
    emit newConnection (file_connection);
}
