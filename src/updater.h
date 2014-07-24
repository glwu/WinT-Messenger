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
    int releaseNumber;
    QNetworkAccessManager *accessManager;

signals:
    void updateAvailable();
};

#endif
