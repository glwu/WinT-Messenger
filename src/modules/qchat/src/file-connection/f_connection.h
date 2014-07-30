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

    FConnection(QObject *parent = 0);

    void sendFile(const QString &path);
    void setDownloadPath(const QString &path);

signals:
    void readyForUse();
    void downloadComplete(const QString &peer_address, const QString &f_name);
    void updateProgress(const QString &peer_address, const QString &d_name, int progress);
    void newDownload(const QString &peer_address, const QString &f_name, const int &f_size);

protected:
    void timerEvent(QTimerEvent *timerEvent);

private slots:
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
    QByteArray buffer;
    QTimer downloadTimer;
    int transferTimerId;
    ConnectionState state;
    QString currentFileName;
    DataType currentDataType;
    bool isGreetingMessageSent;
    int numBytesForCurrentDataType;

    // Used for calculating progress of download
    bool downloadStarted;
    qreal downloadedBytes;
    qreal currentDownloadSize;

    QString downloadPath;

    static const char SEPARATOR_TOKEN = ' ';
    static const int PONG_TIMEOUT = 60 * 1000;
    static const int PING_INTERVAL = 5 * 1000;
    static const int TRANSFER_TIMEOUT = 30 * 1000;
    static const int MAX_BUFFER_SIZE = 1024 * 1000;
};

#endif
