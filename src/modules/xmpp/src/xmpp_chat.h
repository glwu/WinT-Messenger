//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include <QXmppClient.h>

class XmppChat : public QObject {
    Q_OBJECT

public:
    XmppChat() {
        client = new QXmppClient();
    }

    void setDownloadPath(QString path) {
        this->path = path;
    }

    bool login(QString jid, QString passwd) {
        qDebug() << "Logging in with:" << jid;
        client->connectToServer(jid, passwd);
        return false;
    }

private:
    QString path;
    QXmppClient* client;
};
