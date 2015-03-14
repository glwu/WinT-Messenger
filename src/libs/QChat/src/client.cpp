//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  This file is released under the terms of the BSD license.
//

#include "client.h"

Client::Client()
{
    peerManager = new PeerManager (this);
    peerManager->setFileServerPort (f_server.serverPort());
    peerManager->setMessageServerPort (m_server.serverPort());
    peerManager->startBroadcasting();

    connect (&m_server,   SIGNAL (newConnection (MConnection *)),
             this,        SLOT   (newMessageConnection (MConnection *)));
    connect (&f_server,   SIGNAL (newConnection (FConnection *)),
             this,        SLOT   (newFileConnection (FConnection *)));
    connect (peerManager, SIGNAL (newFileConnection (FConnection *)),
             this,        SLOT   (newFileConnection (FConnection *)));
    connect (peerManager, SIGNAL (newMessageConnection (MConnection *)),
             this,        SLOT   (newMessageConnection (MConnection *)));
}

void Client::sendMessage (QString to, const QString& message)
{
    if (!message.isEmpty())
    {
        if (to.isEmpty())
        {
            for (int i = 0; i < m_peers.count(); ++i)
                m_peers.at (i)->sendMessage (message);
        }

        else if (m_peers_names.contains (to))
            m_peers.at (m_peers_names.indexOf (to))->sendMessage (message);
    }
}

void Client::setDownloadPath (const QString& path)
{
    m_download_dir = path;
}

void Client::setProfilePicture (const QImage& image)
{
    QByteArray _ba;
    QBuffer buffer (&_ba);
    image.save (&buffer, "PNG");
    peerManager->profile_picture = _ba;
}

void Client::sendFile (const QString& to, QString path)
{
    if (!path.isEmpty())
    {
        if (to.isEmpty())
        {
            for (int i = 0; i < f_peers.count(); ++i)
                f_peers.at (i)->sendFile (path);
        }

        else if (f_peers_names.contains (to))
            f_peers.at (f_peers_names.indexOf (to))->sendFile (path);
    }
}

void Client::sendStatus (const QString to, const QString &status)
{
    if (!status.isEmpty())
    {
        if (to.isEmpty())
        {
            for (int i = 0; i < m_peers.count(); ++i)
                m_peers.at (i)->sendStatus (status);
        }

        else if (m_peers_names.contains (to))
            m_peers.at (m_peers_names.indexOf (to))->sendStatus (status);
    }
}

void Client::setNickname (const QString& nick)
{
    peerManager->nickname = nick.toUtf8();
}

QString Client::nickName() const
{
    return QString (peerManager->nickname);
}

bool Client::hasConnection (const QHostAddress& senderIp, int senderPort) const
{
    QList<MConnection *> _connections = message_peers.values (senderIp);
    foreach (MConnection * _connection, _connections)
    {
        if (_connection->peerPort() == senderPort)
            return true;
    }
    return false;
}

void Client::newFileConnection (FConnection *fc)
{
    connect (fc,   SIGNAL (readyForUse()),  this, SLOT (readyForUseFile()));
    connect (fc,   SIGNAL (disconnected()), this, SLOT (disconnectedFile()));
    connect (fc,   SIGNAL (error (QAbstractSocket::SocketError)),
             this, SLOT   (connectionErrorFile (QAbstractSocket::SocketError)));
}

void Client::newMessageConnection (MConnection *mc)
{
    mc->setGreetingMessage (peerManager->nickname + '@' +
                            peerManager->profile_picture);

    connect (mc,   SIGNAL (readyForUse()),  this, SLOT (readyForUseMsg()));
    connect (mc,   SIGNAL (disconnected()), this, SLOT (disconnectedMsg()));
    connect (mc,   SIGNAL (error (QAbstractSocket::SocketError)),
             this, SLOT   (connectionErrorMsg (QAbstractSocket::SocketError)));
}

void Client::readyForUseMsg()
{
    MConnection *_connection = qobject_cast<MConnection *> (sender());

    if (!_connection ||
            hasConnection (_connection->peerAddress(), _connection->peerPort()))
        return;

    if (m_peers_names.contains (_connection->id()))
        return;

    connect (_connection, SIGNAL (newMessage (QString, QString)),
             this,        SIGNAL (newMessage (QString, QString)));

    connect (_connection, SIGNAL (statusChanged (QString, QString)),
             this,        SIGNAL (statusChanged (QString, QString)));

    m_peers.append (_connection);
    m_peers_names.append (_connection->id());
    emit newParticipant (_connection->nickname(), _connection->id(), _connection->profilePicture());
}

void Client::disconnectedMsg()
{
    if (MConnection *_connection = qobject_cast<MConnection *> (sender()))
        removeConnectionMsg (_connection);
}

void Client::connectionErrorMsg (QAbstractSocket::SocketError)
{
    if (MConnection *_connection = qobject_cast<MConnection *> (sender()))
        removeConnectionMsg (_connection);
}

void Client::readyForUseFile()
{
    FConnection *_connection = qobject_cast<FConnection *> (sender());

    if (!_connection || hasConnection (_connection->peerAddress(), _connection->peerPort()))
        return;

    if (f_peers_names.contains (_connection->peerName()))
        return;

    connect (_connection, SIGNAL (newDownload (QString, QString, int)),
             this,        SIGNAL (newDownload (QString, QString, int)));
    connect (_connection, SIGNAL (downloadComplete (QString, QString)),
             this,        SIGNAL (downloadComplete (QString, QString)));
    connect (_connection, SIGNAL (updateProgress (QString, QString, int)),
             this,        SIGNAL (updateProgress (QString, QString, int)));

    f_peers.append (_connection);
    f_peers_names.append (_connection->peerName());
}

void Client::disconnectedFile()
{
    if (FConnection *connection = qobject_cast<FConnection *> (sender()))
        removeConnectionFile (connection);
}

void Client::connectionErrorFile (QAbstractSocket::SocketError)
{
    if (FConnection *connection = qobject_cast<FConnection *> (sender()))
        removeConnectionFile (connection);
}

void Client::removeConnectionMsg (MConnection *connection)
{
    m_peers.removeAt (m_peers_names.indexOf (connection->id()));
    m_peers_names.removeAt (m_peers_names.indexOf (connection->id()));
    connection->deleteLater();

    emit participantLeft (connection->nickname(), connection->id());
}

void Client::removeConnectionFile (FConnection *connection)
{
    f_peers.removeAt (f_peers_names.indexOf (connection->peerName()));
    f_peers_names.removeAt (f_peers_names.indexOf (connection->peerName()));
    connection->deleteLater();
}
