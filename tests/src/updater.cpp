//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "updater.h"

//===========================================================================//
//The updater downloads a file from GitHub with the latest release number and//
//version number and compares it to the program's release number.            //
//===========================================================================//

Updater::Updater() {
    newUpdate = false;
    releaseNumber = "0";
    accessManager = new QNetworkAccessManager(this);

    connect(accessManager, SIGNAL(finished(QNetworkReply*)), this,
            SLOT(fileDownloaded(QNetworkReply*)));
    connect(accessManager, SIGNAL(sslErrors(QNetworkReply*,QList<QSslError>)),
            this, SLOT(ignoreSslErrors(QNetworkReply*,QList<QSslError>)));

    QSettings settings("WinT 3794", "WinT Messenger");

    if (settings.value("notifyUpdates", true).toBool())
        checkForUpdates();
}

//============================================================================//
//This function downloads a text file from GitHub and calls the fileDownloaded//
//function to compare the downloaded text file's data with the program's data.//
//============================================================================//

bool Updater::checkForUpdates() {
    QNetworkRequest req(QUrl("https://raw.githubusercontent.com/"
                             "WinT-3794/WinT-Messenger/updater/current.txt"));

    QSslConfiguration config = QSslConfiguration::defaultConfiguration();
    config.setProtocol(QSsl::TlsV1_0);
    req.setSslConfiguration(config);
    accessManager->get(req);
    return newUpdate;
}

//=========================================================================//
//This function transforms the downloaded file into a string, splits it and//
//compares the downloaded release number with the program's release number.//
//=========================================================================//

void Updater::fileDownloaded(QNetworkReply* reply) {
    QByteArray d = reply->readAll();
    QString data = QString::fromUtf8(d);

    if (!data.isEmpty()) {
        QList<QString> list = data.split(";");

        QString release;
        QString version;

        if (list.count() > 1) {
            release = list.at(0);
            version = list.at(1);
        }

        if (release.toInt() > releaseNumber.toInt()) {
            newUpdate = true;
            updateAvailable(version);
        }
    }
}

//===========================================================================//
//This function ensures that the download is not interrupted by an SSL error.//
//===========================================================================//

void Updater::ignoreSslErrors(QNetworkReply *reply, QList<QSslError> error) {
    reply->ignoreSslErrors(error);
}
