#ifndef CHAT_H
#define CHAT_H

#include <QStringList>
#include "client.h"

class LanChat : public QObject {

    Q_OBJECT

public:
    LanChat();

signals:
    void newMessage(const QString &text, bool info);

public slots:
    void returnPressed(QString text);

private slots:
    void appendMessage(const QString &from, const QString &message);
    void newParticipant(QString &nick);
    void participantLeft(QString &nick);

private:
    Client client;
};

#endif
