//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "bridge.h"

Bridge::Bridge() {
    lan_chat = false;
}

//======================================//
//LAN Chat initialization/stop functions//
//======================================//

void Bridge::stopChat() {
    qDeleteAll(chatObjects.begin(), chatObjects.end());
    chatObjects.clear();
    lan_chat = false;
}

void Bridge::startChat() {
    stopChat();

    chat = new Chat();
    chatObjects.append(chat);
    chat->setDownloadPath(getDownloadPath());

    QObject::connect(chat, SIGNAL(delUser(QString)), this,
                     SIGNAL(delUser(QString)));
    QObject::connect(this, SIGNAL(returnPressed(QString)), chat,
                     SLOT(returnPressed(QString)));
    QObject::connect(chat, SIGNAL(newUser(QString, QString)), this,
                     SIGNAL(newUser(QString, QString)));
    QObject::connect(chat, SIGNAL(newMessage(QString, QString, QString, bool)),
                     this, SLOT(messageRecieved(QString, QString, QString, bool)));

    lan_chat = true;
}

//=============================//
//File sharing/saving functions//
//=============================//

QString Bridge::getDownloadPath() {
#if defined(Q_OS_ANDROID)
    return "/sdcard/Download/";
#elif defined(Q_OS_IOS)
    return "/";
#else
    return QDir::tempPath() + "/";
#endif
}

void Bridge::shareFile(const QString path) {
    QString fixedPath = path;
    fixedPath.replace("file:///", "/");

    if (!fixedPath.isEmpty())
        if (lan_chat)
            chat->shareFile(fixedPath);
}

//===================================//
//Message sending/receiving functions//
//===================================//

void Bridge::sendMessage(const QString message) {
    emit returnPressed(message);
}

void Bridge::messageRecieved(const QString &from, const QString &face,
                             const QString &message, bool localUser) {
    QString msg = message;

    msg.replace("[s]", QString("<img src=qrc:/emotes/"));
    msg.replace("[/s]", ".png>");
    msg.replace(QRegExp("((?:https?)://\\S+)"), "<a href=\\1>\\1</a>");

    emit drawMessage(from, face, msg, localUser);
}
