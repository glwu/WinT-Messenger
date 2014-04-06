//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#ifndef NETCHAT_H
#define NETCHAT_H

#include <QColor>
#include <QSettings>

#include "NetClient.h"

class NetChat : public QObject {

    Q_OBJECT

public:
    NetChat();

signals:
    void newMessage(const QString &text);
    void newUser(const QString &nick);
    void delUser(const QString &nick);

public slots:
    void returnPressed(QString text);
    void sendFile(QString fileName);

private slots:
    void newParticipant(const QString &nick);
    void participantLeft(const QString &nick);

private:
    NetClient client;
    QString color;

    QString prepareMessage(const QString message);
};

#endif
