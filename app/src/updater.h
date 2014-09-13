//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef UPDATER_H
#define UPDATER_H

#include <QSsl>
#include <QSslError>
#include <QSettings>
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

        /// Checks for newer releases of WinT Messenger
        /// and returns \c true if a new release is found.
        bool checkForUpdates();

        private
    slots:
        void fileDownloaded (QNetworkReply *reply);
        void ignoreSslErrors (QNetworkReply *reply, QList<QSslError> error);

    signals:
        void updateAvailable();

    private:
        bool m_new_update;
        QNetworkAccessManager *m_access_manager;
};

#endif
