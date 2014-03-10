#ifndef BRIDGE_H
#define BRIDGE_H

#include <QObject>
#include <QStringList>
#include <QApplication>

#include "emotes.h"
#include "lan/chat.h"

class Bridge: public QObject {

    Q_OBJECT

public:
    Bridge();

    Q_INVOKABLE void startLanChat();
    Q_INVOKABLE void stopLanChat();
    Q_INVOKABLE bool hasConnection();

    Q_INVOKABLE void sendMessage(QString text);

private slots:
    void processMessage(const QString &text, bool info);

signals:
    void newMessage(const QString &text);
    void returnPressed(const QString &text);

private:
    LanChat *lanChat;
    Emotes *emotes;

    bool lanChatEnabled;
};

#endif
