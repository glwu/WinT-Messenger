#include "chat.h"

using namespace std;

LanChat::LanChat() {
    connect(&client, SIGNAL(newMessage(QString)), this, SLOT(appendMessage(QString)));

    QSettings *settings = new QSettings("WinT Messenger");
    color = settings->value("userColor", "#00557f").toString();
}

void LanChat::appendMessage(const QString &message) {
    newMessage(message);
}

void LanChat::returnPressed(QString text) {
    if (!text.isEmpty()) {
        QString formattedText = "<font color = '" + color + "'>"
                + "[" + QDateTime::currentDateTime().toString("hh:mm:ss") + "] "
                + "&lt;" + client.nickName() + "&gt;&nbsp; </font>"
                + text;

        client.sendMessage(formattedText);
        newMessage(formattedText);
    }
}
