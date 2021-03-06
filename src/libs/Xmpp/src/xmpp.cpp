//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  Please check the license.txt file for more information.
//

#include "xmpp.h"

Xmpp::Xmpp()
{
    m_client = new QXmppClient();
    m_client->configuration().setResource ("WinT Messenger");
}

Xmpp::~Xmpp()
{
    m_client->disconnectFromServer();
}

void Xmpp::setDownloadPath (const QString& path)
{
    Q_ASSERT (!path.isEmpty());
        m_path = path;
}

void Xmpp::login (const QString& jid, const QString& passwd)
{
    Q_ASSERT (!jid.isEmpty());
    Q_ASSERT (!passwd.isEmpty());

    m_jid = jid;

    //
    // Avoid common issues realted to Facebook accounts...
    // XMPP connections to Facebook only work when we connect to "chat.facebook.com"
    //
    if (m_jid.contains ("@facebook.com") || jid.contains ("@fb.com") || jid.contains ("@chat.fb.com"))
    {
        m_jid.replace ("fb.com", "facebook.com");
        m_jid.replace ("@facebook.com", "@chat.facebook.com");
    }

    //
    // Connect with the specified JID and password
    //
    m_client->connectToServer (m_jid, passwd);

    //
    // Communicate the XMPP client with the rest of the class
    //
    connect (m_client, SIGNAL (connected()), this, SIGNAL (connected()));
    connect (m_client, SIGNAL (disconnected()), this, SIGNAL (disconnected()));
    connect (m_client, SIGNAL (error (QXmppClient::Error)), this, SIGNAL (disconnected()));
    connect (m_client, SIGNAL (messageReceived (QXmppMessage)), this,
             SLOT (messageReceived (QXmppMessage)));
    connect (&m_client->rosterManager(), SIGNAL (rosterReceived()),
             this, SLOT (rosterReceived()));
}

void Xmpp::shareFile (const QString &to, const QString& path)
{
    Q_UNUSED (path);
    Q_UNUSED (to);
}

void Xmpp::sendMessage (const QString &to, const QString &message)
{
    Q_ASSERT (!to.isEmpty());
    Q_ASSERT (!message.isEmpty());

    if (!message.isEmpty() && !to.isEmpty())
        m_client->sendMessage (to, message);

    else
        qWarning() << "Xmpp: Invalid arguments for new message:" << to << message;
}

void Xmpp::sendStatus (const QString &to, const QString &status)
{
    Q_UNUSED (to);
    Q_UNUSED (status);
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
