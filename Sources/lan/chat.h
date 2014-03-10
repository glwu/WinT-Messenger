#ifndef CHAT_H
#define CHAT_H

#include <QColor>
#include <QSettings>

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
    void appendMessage(const QString &message);
    void newParticipant(QString &nick);
    void participantLeft(QString &nick);

private:
    Client client;
    QString color;
};

#endif
