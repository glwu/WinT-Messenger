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

#include <QDir>
#include <QFile>
#include <QImage>
#include <QObject>
#include <QBuffer>
#include <QImageReader>

#include <QXmppUtils.h>
#include <QXmppClient.h>
#include <QXmppMessage.h>
#include <QXmppVCardIq.h>
#include <QXmppVCardManager.h>
#include <QXmppRosterManager.h>

#include "xmpp_global.h"

class XMPP_EXPORT Xmpp : public QObject {
    Q_OBJECT

  public:

    Xmpp();
    ~Xmpp();

  public slots:

    /// Changes the path where Xmpp saves all
    /// downloaded files
    void setDownloadPath (const QString& path);

    /// Connects to a server with the specified
    /// \c JID and \c passwd
    void login (const QString& jid, const QString& passwd);

    /// Sends the specificified file in \c path to the specified
    /// \c peer
    void shareFile (const QString& to, const QString& path);

    /// Sends a status message to the specified peer
    void sendStatus (const QString &to, const QString &status);

    /// Sends a message to the specified peer
    void sendMessage (const QString& to, const QString& message);

  signals:

    void connected();
    void disconnected();
    void delUser (const QString& name, const QString& id);
    void newMessage (const QString& from, const QString& message);
    void presenceChanged (const QString& from, const bool &connected);
    void newUser (const QString& name, const QString& id, const QImage& image);

  private slots:

    void rosterReceived();
    void vCardReceived (const QXmppVCardIq& vCard);
    void messageReceived (const QXmppMessage& message);

  private:

    QString m_jid;
    QString m_path;
    QXmppClient *m_client;

    QStringList jids;
    QStringList users;
};

#endif
