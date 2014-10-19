//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef UPDATER_H
#define UPDATER_H

#include <QSsl>
#include <QSslError>
#include <QByteArray>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QGuiApplication>
#include <QSslConfiguration>
#include <QNetworkAccessManager>

#include "app_info.h"

/*!
 * \class Updater
 *
 * This class is in charge of checking for new
 * updates and (if necessary) notify the user
 * about a new version of WinT Messenger.
 */

class Updater : public QObject
{
        Q_OBJECT

    public:

        Updater();

        /// Returns \c true if there is an update available
        bool checkForUpdates();

    private slots:

        void fileDownloaded (QNetworkReply *reply);
        void ignoreSslErrors (QNetworkReply *reply, QList<QSslError> error);

    signals:

        void updateAvailable(bool newUpdate, const QString &version);

    private:

        bool m_new_update;
        QNetworkAccessManager *m_access_manager;
};

#endif
