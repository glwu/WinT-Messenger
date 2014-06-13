#ifndef NET_CHAT_H
#define NET_CHAT_H

#include <QFile>
#include "client.h"

//============================================================================//
//Why the heck does this class exist?                                         //
//----------------------------------------------------------------------------//
//This class provides an easy and customizable layer between the BRIGDE and   //
//the rest of the LAN chat classes. Also, this class receives instructions    //
//from the BRIDGE and "parses" them to rest of the LAN chat classes.          //
//Examples of this proccess are found when sending a message and/or preparing //
//a file to be sent to the other peers.                                       //
//============================================================================//

class Chat : public QObject {

    Q_OBJECT

public:
    Chat();
    void setDownloadPath(const QString &path);

signals:
    void delUser(const QString &nick);
    void newUser(const QString &nick, const QString &face);
    void newMessage(const QString &from, const QString &face, const QString &message, bool localUser);

public slots:
    void shareFile(const QString &fileName);
    void returnPressed(const QString &message);

private slots:
    void participantLeft(const QString &nick);
    void newParticipant(const QString &nick, const QString &face);
    void receivedFile(const QByteArray &data, const QString &fileName);
    void messageReceived(const QString &from, const QString &face, const QString &message);

private:
    Client client;
    QString downloadPath;
};

#endif
