#ifndef NET_CONNECTION_H
#define NET_CONNECTION_H

#include <QTime>
#include <QTimer>
#include <QString>
#include <QtNetwork>
#include <QTcpSocket>
#include <QHostAddress>

static const int MaxBufferSize = 1024000;

/*==============================================================================*
 * What does this class do?                                                     *
 *------------------------------------------------------------------------------*
 * This class communicates us to another peer (individually) and is in charge   *
 * of getting the peer's name and profile picture. This class also is in charge *
 * of the actual data transfer between us and the connected peer.               *
 *==============================================================================*/

class Connection : public QTcpSocket {
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
        Binary,
        FileName,
        Face,
        Undefined
    };

    Connection(QObject *parent = 0);

    QString name() const;
    QString face() const;

    bool sendFile(const QString &fileName);
    bool sendMessage(const QString &message);
    void setGreetingMessage(const QString &message);

signals:
    void readyForUse();
    void newFile(const QByteArray &buffer, const QString &fileName);
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
    bool readProtocolHeader();
    int dataLengthForCurrentDataType();
    int readDataIntoBuffer(int maxSize = MaxBufferSize);

    QTime pongTime;
    QString username;
    QString userface;
    QTimer pingTimer;
    QByteArray buffer;
    int transferTimerId;
    ConnectionState state;
    QString currentFileName;
    QString greetingMessage;
    DataType currentDataType;
    bool isGreetingMessageSent;
    int numBytesForCurrentDataType;
};

#endif
