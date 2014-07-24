#ifndef MESSAGE_CONNECTION_H
#define MESSAGE_CONNECTION_H

#include <QTime>
#include <QTimer>
#include <QString>
#include <QtNetwork>
#include <QTcpSocket>
#include <QHostAddress>

class MConnection : public QTcpSocket {
    Q_OBJECT

public:
    enum ConnectionState {
        WaitingForGreeting,
        ReadingGreeting,
        ReadyForUse
    };

    enum DataType {
        PlainText,
        Ping,
        Pong,
        Greeting,
        Undefined
    };

    MConnection(QObject *parent = 0);

    QString name() const;
    QString face() const;

    void sendMessage(const QString &message);
    void setGreetingMessage(const QString &message);

signals:
    void readyForUse();
    void newMessage(const QString &from, const QString &face, const QString &message);

protected:
    void timerEvent(QTimerEvent *timerEvent);

private slots:
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
    QString username;
    QString userface;
    QTimer pingTimer;
    QByteArray buffer;
    int transferTimerId;
    ConnectionState state;
    QString greetingMessage;
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
