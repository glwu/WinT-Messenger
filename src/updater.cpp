//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "updater.h"

/*!
 * \brief Updater::Updater
 *
 * Initializes the Updater engine and checks for updates
 * if the value of "notifyUpdates" in the settings registry is true.
 */

Updater::Updater() {
    newUpdate = false;
    releaseNumber = "2";

    accessManager = new QNetworkAccessManager(this);

    connect(accessManager, SIGNAL(finished(QNetworkReply*)), this,
            SLOT(fileDownloaded(QNetworkReply*)));
    connect(accessManager, SIGNAL(sslErrors(QNetworkReply*,QList<QSslError>)),
            this, SLOT(ignoreSslErrors(QNetworkReply*,QList<QSslError>)));

    QSettings settings("WinT 3794", "WinT Messenger");

    if (settings.value("notifyUpdates", true).toBool())
        checkForUpdates();
}

/*!
 * \brief Updater::checkForUpdates
 * \return
 *
 * Downloads a file from <a href=https://raw.githubusercontent.com/WinT-3794/WinT-Messenger/updater\current.txt>
 * GitHub</a> and calls \c Updater::fileDownloaded() and returns the value of \c newUpdate.
 */

bool Updater::checkForUpdates() {
    QNetworkRequest req(QUrl("https://raw.githubusercontent.com/WinT-3794/WinT-Messenger/updater/current.txt"));

    QSslConfiguration config = QSslConfiguration::defaultConfiguration();
    config.setProtocol(QSsl::AnyProtocol);
    req.setSslConfiguration(config);
    accessManager->get(req);
    return newUpdate;
}

/*!
 * \brief Updater::fileDownloaded
 * \param reply
 *
 * Converts the \c reply parameter into a string and compares the
 * current version with the downloaded version and changes the value
 * of \c newUpdate to true if there is a new version available.
 */

void Updater::fileDownloaded(QNetworkReply* reply) {
    QString data = QString::fromUtf8(reply->readAll());

    if (!data.isEmpty()) {
        if (data.toInt() > releaseNumber.toInt()) {
            newUpdate = true;
            updateAvailable();
        }
    }
}

/*!
 * \brief Updater::ignoreSslErrors
 * \param reply
 * \param error
 *
 * Tells the \c accessManager to ignore all SSL errors.
 */

void Updater::ignoreSslErrors(QNetworkReply *reply, QList<QSslError> error) {
    reply->ignoreSslErrors(error);
}
