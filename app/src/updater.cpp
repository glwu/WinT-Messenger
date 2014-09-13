//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "updater.h"

Updater::Updater()
{
    m_new_update = false;
    m_access_manager = new QNetworkAccessManager (this);

    connect (m_access_manager, SIGNAL (finished (QNetworkReply *)),
             this,             SLOT   (fileDownloaded (QNetworkReply *)));
    connect (m_access_manager, SIGNAL (sslErrors (QNetworkReply *, QList<QSslError>)),
             this,             SLOT   (ignoreSslErrors (QNetworkReply *, QList<QSslError>)));

    QSettings _settings ("WinT 3794", "WinT Messenger");

    if (_settings.value ("notifyUpdates", true).toBool())
        checkForUpdates();
}

bool Updater::checkForUpdates()
{
    QNetworkRequest _req (QUrl (UPDATE_URL));
    QSslConfiguration _config = QSslConfiguration::defaultConfiguration();
    _config.setProtocol (QSsl::AnyProtocol);
    _req.setSslConfiguration (_config);
    m_access_manager->get (_req);
    return m_new_update;
}

void Updater::fileDownloaded (QNetworkReply *reply)
{
    QString _data = QString::fromUtf8 (reply->readAll());

    if (!_data.isEmpty())
    {
        if (_data.toInt() > CURRENT_RELEASE)
        {
            m_new_update = true;
            updateAvailable();
        }
    }
}

void Updater::ignoreSslErrors (QNetworkReply *reply, QList<QSslError> error)
{
    reply->ignoreSslErrors (error);
}
