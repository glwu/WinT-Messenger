//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
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
    // Prepare the variables
    newUpdate = false;

    // For each public release, we need to increase the release number counter.
    releaseNumber = 2;

    // Create and configure a new QNetworkAccessManager
    accessManager = new QNetworkAccessManager(this);

    // Allow the program to analyze the downloaded file
    connect(accessManager, SIGNAL(finished(QNetworkReply*)), this,
            SLOT(fileDownloaded(QNetworkReply*)));

    // Ignore all SSL errors
    connect(accessManager, SIGNAL(sslErrors(QNetworkReply*,QList<QSslError>)),
            this, SLOT(ignoreSslErrors(QNetworkReply*,QList<QSslError>)));

    // Check for updates only if the user specified that he/she wants to
    // get notified about new updates
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
    // Prepare a request to download a file from GitHub
    QNetworkRequest req(QUrl("https://raw.githubusercontent.com/WinT-3794/WinT-Messenger/updater/current.txt"));

    // Prepare the SSL configuration to accept any protocol
    QSslConfiguration config = QSslConfiguration::defaultConfiguration();
    config.setProtocol(QSsl::AnyProtocol);

    // Apply the customized configuration
    req.setSslConfiguration(config);

    // Download the file
    accessManager->get(req);

    // Return the analyzed value in the fileDownloaded() function
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
    // Read the downloaded contents
    QString data = QString::fromUtf8(reply->readAll());

    // Only analyze the data if the downloaded data is not empty
    if (!data.isEmpty()) {

        // Convert the downloaded data and compare it to the current
        // release number. If the downloaded data is greater that the current
        // release. We will notify the user about a new version of the app.
        if (data.toInt() > releaseNumber) {
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
