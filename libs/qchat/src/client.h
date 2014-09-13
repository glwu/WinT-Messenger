//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  This file is released under the terms of the BSD license.
//

#ifndef NET_CLIENT_H
#define NET_CLIENT_H

#include <math.h>

#include <QHash>
#include <QtNetwork>
#include <QHostAddress>
#include <QAbstractSocket>

#include "peermanager.h"
#include "file-connection/f_server.h"
#include "message-connection/m_server.h"
#include "file-connection/f_connection.h"
#include "message-connection/m_connection.h"

class PeerManager;

class Client : public QObject
{
        Q_OBJECT

    public:
        Client();
        PeerManager *peerManager;

        /*!
         * \brief nickName
         * \return
         *
         * Returns the nickname of the user, which is applied
         * using the Client::setNickname() function.
         */

        QString nickName() const;

        /*!
         * \brief setNickname
         * \param nick
         *
         * Changes the nickname of the user.
         */

        void setNickname (const QString& nick);

        /*!
         * \brief setDownloadPath
         * \param path
         *
         * Changes the path where the program saves all downloaded
         * files.
         */

        void setDownloadPath (const QString& path);

        /*!
         * \brief setProfilePicture
         * \param image
         *
         * Changes the profile picture of the user
         */

        void setProfilePicture (const QImage& image);

        /*!
         * \brief sendFile
         * \param path
         * \param peer
         *
         * Sends the file given in \c path to the choosen \c peer
         */

        void sendFile (const QString& path, QString peer);

        /*!
         * \brief sendMessage
         * \param message
         * \param peer
         *
         * Sends the given message to the given peer
         */

        void sendMessage (QString to, const QString& message);

        /*!
         * \brief hasConnection
         * \param senderIp
         * \param senderPort
         * \return
         */

        bool hasConnection (const QHostAddress& senderIp, int senderPort = -1) const;

    signals:
        void participantLeft (const QString& nick, const QString& id);
        void newMessage (const QString& from, const QString& message);
        void downloadComplete (const QString& nick, const QString& file);
        void newDownload (const QString& name, const QString& file, int size);
        void newParticipant (const QString& nick, const QString &id, const QImage& profile_picture);
        void updateProgress (const QString& name, const QString& file, int progress);

        private
    slots:
        void readyForUseMsg();
        void disconnectedMsg();
        void connectionErrorMsg (QAbstractSocket::SocketError socketError);

        void readyForUseFile();
        void disconnectedFile();
        void connectionErrorFile (QAbstractSocket::SocketError socketError);

        void newFileConnection (FConnection *fc);
        void newMessageConnection (MConnection *mc);

    private:
        MServer m_server;
        FServer f_server;

        QString m_download_dir;

        QMultiHash<QHostAddress, FConnection *> file_peers;
        QMultiHash<QHostAddress, MConnection *> message_peers;

        QList<FConnection *> f_peers;
        QList<MConnection *> m_peers;
        QList<QString> m_peers_names;
        QList<QString> f_peers_names;

        void removeConnectionMsg (MConnection *connection);
        void removeConnectionFile (FConnection *connection);
};

#endif
