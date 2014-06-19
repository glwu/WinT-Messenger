//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "f_server.h"

/*!
 * \brief FServer::FServer
 * \param parent
 *
 * Initializes the \c FServer and begins listening for any incoming connections
 * from any interface.
 */

FServer::FServer(QObject *parent) : QTcpServer(parent) {
    listen(QHostAddress::Any);
}

/*!
 * \brief FServer::incomingConnection
 * \param socketDescriptor
 *
 * Creates a new \c FConnection and tells the \c Client that
 * a new peer wants to join the room.
 */

void FServer::incomingConnection(qintptr socketDescriptor) {
    FConnection *file_connection = new FConnection(this);
    file_connection->setSocketDescriptor(socketDescriptor);
    emit newConnection(file_connection);
}
