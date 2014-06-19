//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "m_server.h"

/*!
 * \brief MServer::MServer
 * \param parent
 *
 * Initializes the \c MServer and begins listening for any incoming connections
 * from any interface.
 */

MServer::MServer(QObject *parent) : QTcpServer(parent) {
    listen(QHostAddress::Any);
}

/*!
 * \brief MServer::incomingConnection
 * \param socketDescriptor
 *
 * Creates a new \c MConnection and tells the \c Client that
 * a new peer wants to join the room.
 */

void MServer::incomingConnection(qintptr socketDescriptor) {
    MConnection *message_connection = new MConnection(this);
    message_connection->setSocketDescriptor(socketDescriptor);

    emit newConnection(message_connection);
}
