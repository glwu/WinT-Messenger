//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "m_server.h"

MServer::MServer (QObject *parent) : QTcpServer (parent)
{
    listen (QHostAddress::Any);
}

void MServer::incomingConnection (qintptr socketDescriptor)
{
    MConnection *message_connection = new MConnection (this);
    message_connection->setSocketDescriptor (socketDescriptor);
    emit newConnection (message_connection);
}
