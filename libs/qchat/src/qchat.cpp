//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "qchat.h"

QChat::QChat()
{
    connect (&client, SIGNAL (participantLeft (QString, QString)),
             this,    SIGNAL (delUser (QString, QString)));
    connect (&client, SIGNAL (newParticipant (QString, QString, QImage)),
             this,    SLOT   (processNewUser (QString, QString, QImage)));
    connect (&client, SIGNAL (newDownload (QString, QString, int)),
             this,    SIGNAL (newDownload (QString, QString, int)));
    connect (&client, SIGNAL (downloadComplete (QString, QString)),
             this,    SIGNAL (downloadComplete (QString, QString)));
    connect (&client, SIGNAL (updateProgress (QString, QString, int)),
             this,    SIGNAL (updateProgress (QString, QString, int)));
    connect (&client, SIGNAL (newMessage (QString, QString)),
             this,    SIGNAL (newMessage (QString, QString)));
}

void QChat::setNickname (const QString& nick)
{
    client.setNickname (nick);
}

void QChat::setProfilePicture (const QImage& image)
{
    client.setProfilePicture (image);
}

void QChat::setDownloadPath (const QString& path)
{
    client.setDownloadPath (path);
}

void QChat::shareFile (const QString& path, const QString& peer)
{
    client.sendFile (path, peer);
    QFile file (path);
    emit newMessage (NULL,
                     QString ("You shared <a href='file://%1'>%2</a>")
                     .arg (path, QFileInfo (file).fileName()));
    file.close();
}

void QChat::returnPressed (const QString& to, const QString &message)
{
    QString msg = message;
    msg.replace ("<", "&lt;");
    msg.replace (">", "&gt;");
    client.sendMessage (to, message);
}

void QChat::processNewUser (const QString &name, const QString &id, const QImage &image)
{
    emit newUser (name, id, image);
}
