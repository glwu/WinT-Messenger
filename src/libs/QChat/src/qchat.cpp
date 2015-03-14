//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
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
    connect (&client, SIGNAL (statusChanged (QString, QString)),
             this,    SIGNAL (statusChanged (QString, QString)));
}

void QChat::setNickname (const QString& nick)
{
    Q_ASSERT (!nick.isEmpty());

    if (!nick.isEmpty())
        client.setNickname (nick);

    else
        qWarning() << "QChat: Nickname cannot be empty!";
}

void QChat::setProfilePicture (const QImage& image)
{
    Q_ASSERT (!image.isNull());

    if (!image.isNull())
        client.setProfilePicture (image);

    else
        qWarning() << "QChat: Invalid profile picture!";
}

void QChat::setDownloadPath (const QString& path)
{
    Q_ASSERT (!path.isEmpty());

    if (!path.isEmpty())
        client.setDownloadPath (path);

    else
        qWarning() << "QChat: Download path cannot be empty!";
}

void QChat::sendStatus (const QString &to, const QString &status)
{
    Q_ASSERT (!status.isEmpty());

    if (!status.isEmpty())
        client.sendStatus (to, status);

    else
        qWarning() << "QChat: Status message cannot be empty!";
}

void QChat::shareFile (const QString& to, const QString& path)
{
    Q_ASSERT (!path.isEmpty());

    if (!path.isEmpty())
        client.sendFile (to, path);

    else
        qWarning() << "QChat: File path cannot be empty!";
}

void QChat::returnPressed (const QString& to, const QString &message)
{
    Q_ASSERT (!message.isEmpty());

    if (!message.isEmpty())
    {
        QString msg = message;
        msg.replace ("<", "&lt;");
        msg.replace (">", "&gt;");
        client.sendMessage (to, message);
    }

    else
        qWarning() << "QChat: Message cannot be empty!";
}

void QChat::processNewUser (const QString &name, const QString &id, const QImage &image)
{
    Q_ASSERT (!id.isEmpty());
    Q_ASSERT (!name.isEmpty());
    Q_ASSERT (!image.isNull());

    emit newUser (name, id, image);
}
