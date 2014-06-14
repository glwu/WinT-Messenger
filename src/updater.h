//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
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


/*==============================================================================*
 * What does this class do?                                                     *
 *------------------------------------------------------------------------------*
 * This class is in charge of notifying the QML interface if a new update is    *
 * available. Basically, we download a text file from GitHub and compare it     *
 * With the application version that we have.                                   *
 * The format of the text file is RELEASE_NUMBER;APPLICATION_VERSION.           *
 * The semicolon (;) is used to split the string and use the RELEASE_NUMBER to  *
 * determine if a newer release is available.                                   *
 *==============================================================================*/

class Updater : public QObject {

    Q_OBJECT

public:
    Updater();
    Q_INVOKABLE bool checkForUpdates();

private slots:
    void fileDownloaded(QNetworkReply* reply);
    void ignoreSslErrors(QNetworkReply* reply,QList<QSslError> error);

private:
    bool newUpdate;
    QString releaseNumber;
    QNetworkAccessManager *accessManager;

signals:
    void updateAvailable();
};

#endif
