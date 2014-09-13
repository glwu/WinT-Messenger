//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef BRIDGE_H
#define BRIDGE_H

#include <QSound>
#include <QImage>
#include <QFileDialog>
#include <QDomDocument>

#include <xmpp.h>
#include <qchat.h>

#include "updater.h"
#include "platforms.h"
#include "image_provider.h"
#include "device_manager.h"

/*!
 * \class Bridge
 *
 * The Bridge class is in charge of communicating most of the
 * C++ interface with the QML interface.
 *
 * Additionally, the Bridge class starts and stops the installed
 * chat modules, which are:
 *     - qChat module: for LAN chat with basic TCP/IP programming
 *     - XMPP chat module: for online chat services with XMPP, such as
 *                         GMail and Facebook.
 */

class Bridge : public QObject
{
    Q_OBJECT

public:
    Bridge();

    /*!
         * \brief stopLanChat
         */

    Q_INVOKABLE void stopLanChat();

    /*!
         * \brief startLanChat
         */

    Q_INVOKABLE void startLanChat();

    /*!
         * \brief stopXmpp
         */

    Q_INVOKABLE void stopXmpp();

    /*!
         * \brief startXmpp
         * \param jid
         * \param passwd
         */

    Q_INVOKABLE void startXmpp (QString jid, QString passwd);

    /*!
         * \brief playSound
         * \param name
         */

    Q_INVOKABLE void playSound (QString name);

    /*!
         * \brief shareFiles
         * \param peer
         */

    Q_INVOKABLE void shareFiles (const QString& peer);

    /*!
         * \brief sendMessage
         * \param to
         * \param message
         */

    Q_INVOKABLE void sendMessage (const QString& to, const QString &message);

    /*!
         * \brief getId
         * \param nickname
         * \return
         */

    Q_INVOKABLE QString getId (QString nickname);

    /*!
         * \brief downloadPath
         * \return
         */

    Q_INVOKABLE QString downloadPath();

    /*!
         * \brief manageSmileys
         * \param data
         * \return
         */

    Q_INVOKABLE QString manageSmileys (const QString &data);

    /*!
         * \brief checkForUpdates
         * \return
         */

    Q_INVOKABLE bool checkForUpdates();

    DeviceManager manager;
    ImageProvider *imageProvider;

signals:
    void xmppConnected();
    void xmppDisconnected();
    void updateAvailable();
    void delUser (QString nick, QString id);
    void newUser (QString nick, QString id);
    void drawMessage (QString from, QString message);
    void returnPressed (QString message, QString peer);
    void downloadComplete (QString name, QString file);
    void newDownload (QString name, QString file, int size);
    void updateProgress (QString name, QString file, int progress);

private slots:
    void processNewUser (const QString& nickname, const QString& id, const QImage& profilePicture);

private:
    Xmpp *m_xmpp;
    QChat *m_qchat;
    QSound *m_sound;
    Updater *m_updater;

    QStringList m_uuids;
    QStringList m_nicknames;

    bool m_xmpp_enabled;
    bool m_qchat_enabled;

    QList<Xmpp *> m_xmpp_objects;
    QList<QChat *> m_qchat_objects;
};

#endif
