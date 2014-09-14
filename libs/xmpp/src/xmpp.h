//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef XMPP_H
#define XMPP_H

#include <iostream>

#include <QDir>
#include <QFile>
#include <QImage>
#include <QBuffer>
#include <QXmlReader>
#include <QImageReader>

#include <QXmppUtils.h>
#include <QXmppClient.h>
#include <QXmppMessage.h>
#include <QXmppVCardIq.h>
#include <QXmppVCardManager.h>
#include <QXmppRosterManager.h>

/*!
 * \brief The Xmpp class
 *
 * The Xmpp class is a simple module based on the Gloox library.
 * It allows us to send and receive data from any XMPP/Jabber service provider.
 *
 * This class has support for the following:
 *     - Sending/receiving messages from XMPP servers
 *     - Sending/receiving files from XMPP servers
 *     - Getting information related to user avaiability.
 *     - Getting user information such as profile pictures.
 *
 * You may have asked yourself why we didn't use QXmpp, the answer is that Gloox
 * is also supported on iOS and Android.
 */

class Xmpp : public QObject
{
        Q_OBJECT

    public:
        Xmpp();
        ~Xmpp();

        public
    slots:
        void setDownloadPath (const QString& path);
        void login (const QString& jid, const QString& passwd);
        void shareFile (const QString& path, const QString& peer);

    public slots:
        void sendMessage (const QString& to, const QString& message);

    signals:
        void connected();
        void disconnected();
        void delUser (const QString& name, const QString& id);
        void newUser (const QString& name, const QString& id, const QImage& image);
        void newMessage (const QString& from, const QString& message);

        private
    slots:
        void rosterReceived();
        void vCardReceived (const QXmppVCardIq& vCard);
        void messageReceived (const QXmppMessage& message);
        void presenceChanged (const QString& bareJid, const QString& resource);

    private:
        QString m_jid;
        QString m_path;
        QXmppClient *m_client;

        QStringList jids;
        QStringList users;
};

#endif
