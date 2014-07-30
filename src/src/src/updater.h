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

#include <qssl.h>
#include <qsslerror.h>
#include <qsettings.h>
#include <qbytearray.h>
#include <qnetworkreply.h>
#include <qnetworkrequest.h>
#include <qguiapplication.h>
#include <qsslconfiguration.h>
#include <qnetworkaccessmanager.h>

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
