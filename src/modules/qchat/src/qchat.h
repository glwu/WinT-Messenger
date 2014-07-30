//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#ifndef QCHAT_H
#define QCHAT_H

#include "client.h"

class QChat : public QObject {
    Q_OBJECT

public:
    QChat();

    void setColor(const QString &color);
    void setNickname(const QString &nick);
    void setUserFace(const QString &face);
    void setDownloadPath(const QString &path);

    QString getDownloadPath();

public slots:
    void shareFile(const QString &path);
    void returnPressed(const QString &message);

private slots:
    void messageReceived(const QString &from, const QString &face,
                         const QString &message);

signals:
    void delUser(const QString &nick);
    void newUser(const QString &nick, const QString &face);
    void downloadComplete(const QString &peer_address, const QString &f_name);
    
    void updateProgress(const QString &peer_address, const QString &d_name,
                        int progress);

    void newDownload(const QString &peer_address, const QString &f_name,
                     const int &f_size);

    void newMessage(const QString &from, const QString &face,
                    const QString &message, const QString &color,
                    char localUser);

private:
    Client client;

    QString downloadPath;
    QString color;
};

#endif
