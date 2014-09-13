//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef QCHAT_H
#define QCHAT_H

#include "client.h"

/*!
 * \brief The QChat class
 *
 * The qChat class allows us to implement a LAN chat
 * application based on basic TCP/IP programming.
 *
 * The class supports the following features:
 *     - File sharing
 *     - Users with custom nicknames and application
 *       independent profile pictures.
 *     - Download information, such as the progress
 *       of a specific download.
 *
 * The class is configured automatically upon initialization,
 * however, the developer must manually specify the following:
 *     - User nickname (as QString)
 *     - Profile picture (as QImage)
 *     - Download path (as QString)
 *
 * You can find an example that shows you how to implement this class
 * in the examples directory of the QChat module.
 */

class QChat : public QObject
{
        Q_OBJECT

    public:
        QChat();

        void setNickname (const QString& nick);
        void setDownloadPath (const QString& path);
        void setProfilePicture (const QImage& image);

    public slots:
        void shareFile (const QString& path, const QString &peer);
        void returnPressed (const QString& to, const QString& message);

    private slots:
        void processNewUser (const QString& name, const QString &id, const QImage& image);

    signals:
        void delUser (const QString& nick, const QString& id);
        void newMessage (const QString& from, const QString& message);
        void downloadComplete (const QString& from, const QString& file);
        void newUser (const QString& nick, const QString& id, const QImage& face);
        void updateProgress (const QString& from, const QString& file, int progress);
        void newDownload (const QString& from, const QString& file, const int& size);

    private:
        Client client;
};

#endif
