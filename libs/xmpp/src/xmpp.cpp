//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "xmpp.h"

Xmpp::Xmpp()
{
    m_client = new QXmppClient();
    m_client->logger()->setLoggingType (QXmppLogger::NoLogging);
}

Xmpp::~Xmpp()
{
    m_client->disconnectFromServer();
}

void Xmpp::setDownloadPath (const QString& path)
{
    m_path = path;
}

void Xmpp::login (const QString& jid, const QString& passwd)
{
    m_jid = jid;
    m_client->connectToServer (jid, passwd);

    connect (m_client, SIGNAL (connected()), this, SIGNAL (connected()));
    connect (m_client, SIGNAL (disconnected()), this, SIGNAL (disconnected()));
    connect (m_client, SIGNAL (error (QXmppClient::Error)), this, SIGNAL (disconnected()));
    connect (m_client, SIGNAL (messageReceived (QXmppMessage)), this, SLOT (messageReceived (QXmppMessage)));

    connect (&m_client->rosterManager(), SIGNAL (rosterReceived()),
             this, SLOT (rosterReceived()));
    connect (&m_client->rosterManager(), SIGNAL (presenceChanged (QString, QString)),
             this, SLOT (presenceChanged (QString, QString)));
}

void Xmpp::shareFile (const QString& path, const QString &peer)
{
    Q_UNUSED (path);
    Q_UNUSED (peer);
}

void Xmpp::sendMessage (const QString &to, const QString &message)
{
    m_client->sendMessage (to, message);
}

void Xmpp::rosterReceived()
{
    QStringList list = m_client->rosterManager().getRosterBareJids();
    connect (&m_client->vCardManager(), SIGNAL (vCardReceived (QXmppVCardIq)),
             this, SLOT (vCardReceived (QXmppVCardIq)));

    for (int i = 0; i < list.size(); ++i)
        m_client->vCardManager().requestVCard (list.at (i));
}

void Xmpp::vCardReceived (const QXmppVCardIq& vCard)
{
    QByteArray photo = vCard.photo();
    QBuffer buffer;
    buffer.setData (photo);
    buffer.open (QIODevice::ReadOnly);
    QImageReader imageReader (&buffer);
    QImage image = imageReader.read();

    if (image.isNull())
        image = QImage (":/faces/faces/generic-user.png");

    jids.append (vCard.from());
    users.append (vCard.fullName());

    emit newUser (vCard.fullName(), vCard.from(), image);
}

void Xmpp::messageReceived (const QXmppMessage &message)
{
    QString body = message.body();
    QString peer = users.at (jids.indexOf (QXmppUtils::jidToBareJid (message.from())));
    emit newMessage (peer, body);
}

void Xmpp::presenceChanged (const QString& bareJid,
                            const QString& resource)
{
    Q_UNUSED (bareJid);
    Q_UNUSED (resource);
}
