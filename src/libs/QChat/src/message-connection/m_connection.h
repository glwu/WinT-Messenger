//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  This file is released under the terms of the BSD license.
//

#ifndef MESSAGE_CONNECTION_H
#define MESSAGE_CONNECTION_H

#include <QTime>
#include <QTimer>
#include <QImage>
#include <QString>
#include <QtNetwork>
#include <QTcpSocket>
#include <QHostAddress>


class MConnection : public QTcpSocket
{
        Q_OBJECT

    public:
        enum ConnectionState
        {
            WaitingForGreeting,
            ReadingGreeting,
            ReadyForUse
        };

        enum DataType
        {
            PlainText,
            Ping,
            Pong,
            Greeting,
            Status,
            Undefined
        };

        MConnection (QObject *parent = 0);

        QString id() const;
        QString nickname() const;
        QImage profilePicture() const;

        void sendStatus  (const QString& status);
        void sendMessage (const QString& message);
        void setGreetingMessage (const QByteArray& message);

    signals:
        void readyForUse();
        void statusChanged (const QString &id, const QString &status);
        void newMessage (const QString& from, const QString& message);

    protected:
        void timerEvent (QTimerEvent *timerEvent);

        private
    slots:
        void sendPing();
        void processReadyRead();
        void sendGreetingMessage();

    private:
        void processData();
        bool hasEnoughData();
        int readDataIntoBuffer();
        bool readProtocolHeader();
        int dataLengthForCurrentDataType();

        QTime pongTime;
        QString m_nickname;
        QTimer pingTimer;
        QByteArray buffer;
        int transferTimerId;
        ConnectionState state;
        QImage profile_picture;
        QByteArray greetingMessage;
        DataType currentDataType;
        bool isGreetingMessageSent;
        int numBytesForCurrentDataType;

        static const char SEPARATOR_TOKEN = ' ';
        static const int PONG_TIMEOUT = 60 * 1000;
        static const int PING_INTERVAL = 5 * 1000;
        static const int TRANSFER_TIMEOUT = 30 * 1000;
        static const int MAX_BUFFER_SIZE = 1024 * 1000;
};

#endif
