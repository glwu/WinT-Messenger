#ifndef NET_CHAT_H
#define NET_CHAT_H

#include <QFile>
#include <QSettings>

#include "client.h"

class Chat : public QObject {

    Q_OBJECT

public:
    Chat();
    void setDownloadPath(const QString &path);

signals:
    void delUser(const QString &nick);
    void newUser(const QString &nick, const QString &face);
    void updateProgress(const QString &peer_address, int progress);
    void downloadComplete(const QString &peer_address, const QString &f_name);
    void newDownload(const QString &peer_address, const QString &f_name, const int &f_size);
    void newMessage(const QString &from, const QString &face, const QString &message, char localUser);

public slots:
    void shareFile(const QString &path);
    void returnPressed(const QString &message);

private slots:
    void participantLeft(const QString &nick);
    void newParticipant(const QString &nick, const QString &face);
    void receivedFile(const QByteArray &data, const QString &fileName);
    void messageReceived(const QString &from, const QString &face, const QString &message);

private:
    Client client;
    QString downloadPath;
    QString userColor;
};

#endif
