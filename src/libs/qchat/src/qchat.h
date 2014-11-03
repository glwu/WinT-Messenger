//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef QCHAT_H
#define QCHAT_H

#include "client.h"

class QChat : public QObject
{
        Q_OBJECT

    public:

        QChat();

    public slots:

        /// Changes the nickname to be shown to the connected
        /// peers
        void setNickname (const QString& nick);

        /// Changes the path in which QChat saves all downloaded
        /// files
        void setDownloadPath (const QString& path);

        /// Changes the user's profile picture
        void setProfilePicture (const QImage& image);

        /// Sends a status message to specified peer.
        /// Use a blank string in the \to parameter to send the
        /// status message to every user
        void sendStatus (const QString &to, const QString &status);

        /// Sends a file in \path to specified \peer.
        /// Use a blank string to send the file to all peers
        void shareFile (const QString& to, const QString &path);

        /// Sends a message to specified peer.
        /// Use a blank string in the \to parameter to send the
        /// message to every peer
        void returnPressed (const QString& to, const QString& message);


    signals:

        void delUser (const QString& nick, const QString& id);
        void statusChanged (const QString &id, const QString &status);
        void newMessage (const QString& from, const QString& message);
        void downloadComplete (const QString& from, const QString& file);
        void newUser (const QString& nick, const QString& id, const QImage& face);
        void updateProgress (const QString& from, const QString& file, int progress);
        void newDownload (const QString& from, const QString& file, const int& size);


    private slots:

        void processNewUser (const QString& name, const QString &id, const QImage& image);

    private:

        Client client;
};

#endif
