//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  This file is released under the terms of the BSD license.
//

#ifndef FILE_CONNECTION_H
#define FILE_CONNECTION_H

#include <QTime>
#include <QTimer>
#include <QString>
#include <QtNetwork>
#include <QTcpSocket>
#include <QHostAddress>

class FConnection : public QTcpSocket {
    Q_OBJECT

  public:
    enum ConnectionState {
        WaitingForGreeting,
        ReadingGreeting,
        ReadyForUse
    };

    enum DataType {
        Ping,
        Pong,
        Greeting,
        Binary,
        FileData,
        Undefined
    };

    FConnection (QObject *parent = 0);

    void sendFile (const QString& path);
    void setDownloadPath (const QString& path);

  signals:
    void readyForUse();
    void downloadComplete (const QString& name, const QString& file);
    void updateProgress (const QString& name, const QString& file, int progress);
    void newDownload (const QString& name, const QString& file, const int& size);

  protected:
    void timerEvent (QTimerEvent *timerEvent);

    private
  slots:
    void sendPing();
    void processReadyRead();
    void sendGreetingMessage();
    void calculateDownloadProgress();

  private:
    void processData();
    bool hasEnoughData();
    int readDataIntoBuffer();
    bool readProtocolHeader();
    int dataLengthForCurrentDataType();

    QTime pongTime;
    QTimer pingTimer;
    QString m_nickname;
    QByteArray buffer;
    QTimer downloadTimer;
    int transferTimerId;
    ConnectionState state;
    QString currentFileName;
    DataType currentDataType;
    bool isGreetingMessageSent;
    int numBytesForCurrentDataType;

    bool downloadStarted;
    qreal downloadedBytes;
    qreal currentDownloadSize;

    QString m_download_dir;

    static const char SEPARATOR_TOKEN = ' ';
    static const int PONG_TIMEOUT = 60 * 1000;
    static const int PING_INTERVAL = 5 * 1000;
    static const int TRANSFER_TIMEOUT = 30 * 1000;
    static const int MAX_BUFFER_SIZE = 1024 * 1000;
};

#endif
