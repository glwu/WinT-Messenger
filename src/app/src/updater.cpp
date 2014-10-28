//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "updater.h"

Updater::Updater() {
    m_access_manager = new QNetworkAccessManager (this);
    connect (m_access_manager, SIGNAL (finished (QNetworkReply *)),
             this,             SLOT   (fileDownloaded (QNetworkReply *)));
    connect (m_access_manager, SIGNAL (sslErrors (QNetworkReply *, QList<QSslError>)),
             this,             SLOT   (ignoreSslErrors (QNetworkReply *, QList<QSslError>)));
}

void Updater::checkForUpdates() {
    m_access_manager->get (QNetworkRequest (QUrl (UPDATE_URL)));
}

void Updater::fileDownloaded (QNetworkReply *reply) {
    bool _new_update = false;

    QString _reply = QString::fromUtf8 (reply->readAll());

    if (!_reply.isEmpty()) {
        QStringList _download = _reply.split (".");
        QStringList _installed = QString (APP_VERSION).split (".");

        if (_download.count() == _installed.count()) {
            for (int i = 0; i <= _download.count() - 1; ++i) {
                if (_download.at (i) > _installed.at (i)) {
                    _new_update = true;
                    break;
                }
            }
        }
    }

    emit updateAvailable (_new_update, _reply);
}

void Updater::ignoreSslErrors (QNetworkReply *reply, QList<QSslError> error) {
    reply->ignoreSslErrors (error);
}
