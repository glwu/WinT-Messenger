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

signals:
    void readyForUse();
    void updateProgress(const QString &peer_address, int progress);
    void newFile(const QByteArray &buffer, const QString &fileName);
    void downloadComplete(const QString &peer_address, const QString &f_name);
    void newDownload(const QString &peer_address, const QString &f_name, const int &f_size);

protected:
    void timerEvent(QTimerEvent *timerEvent);

private slots:
    void sendPing();
    void processReadyRead();
    void sendGreetingMessage();
    void calculateDownloadProgress(qint64 recievedBytes);

private:
    void processData();
    bool hasEnoughData();
    int readDataIntoBuffer();
    bool readProtocolHeader();
    int dataLengthForCurrentDataType();

    QTime pongTime;
    QTimer pingTimer;
    QByteArray buffer;
    int transferTimerId;
    ConnectionState state;
    QString currentFileName;
    DataType currentDataType;
    bool isGreetingMessageSent;
    int numBytesForCurrentDataType;

    // Used for calculating progress of download
    bool downloadStarted;
    int downloadedBytes;
    int currentDownloadSize;

    static const char SeparatorToken = ' ';
    static const int PongTimeout = 60 * 1000;
    static const int PingInterval = 5 * 1000;
    static const int MaxBufferSize = 1024000;
    static const int TransferTimeout = 30 * 1000;
};

#endif
