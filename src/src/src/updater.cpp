//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "updater.h"

/// Initializes the Updater engine and checks for updates
/// if the value of "notifyUpdates" in the settings registry is true.
Updater::Updater() {
    newUpdate = false;
    releaseNumber = 2;
    accessManager = new QNetworkAccessManager(this);

    connect(accessManager, SIGNAL(finished(QNetworkReply*)), this,
            SLOT(fileDownloaded(QNetworkReply*)));
    connect(accessManager, SIGNAL(sslErrors(QNetworkReply*,QList<QSslError>)),
            this, SLOT(ignoreSslErrors(QNetworkReply*,QList<QSslError>)));

    QSettings settings("WinT 3794", "WinT Messenger");
    if (settings.value("notifyUpdates", true).toBool())
        checkForUpdates();
}

/// Downloads a file from GitHub, calls \c Updater::fileDownloaded()
/// and returns the value of \c newUpdate.
bool Updater::checkForUpdates() {
    QNetworkRequest req(QUrl("https://raw.githubusercontent.com/WinT-3794/"
                             "WinT-Messenger/updater/current.txt"));

    QSslConfiguration config = QSslConfiguration::defaultConfiguration();
    config.setProtocol(QSsl::AnyProtocol);

    req.setSslConfiguration(config);
    accessManager->get(req);

    return newUpdate;
}

/// Converts the \c reply parameter into a string and compares the
/// current version with the downloaded version and changes the value
/// of \c newUpdate to true if there is a new version available.
///
/// \param reply the QNetworkReply data
void Updater::fileDownloaded(QNetworkReply* reply) {
    QString data = QString::fromUtf8(reply->readAll());

    if (!data.isEmpty()) {
        if (data.toInt() > releaseNumber) {
            newUpdate = true;
            updateAvailable();
        }
    }
}

/// Tells the \c accessManager to ignore all SSL errors.
///
/// \param reply
/// \param error
void Updater::ignoreSslErrors(QNetworkReply *reply, QList<QSslError> error) {
    reply->ignoreSslErrors(error);
}
