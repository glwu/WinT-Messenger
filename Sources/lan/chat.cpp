#include "chat.h"

using namespace std;

LanChat::LanChat() {
    connect(&client, SIGNAL(newMessage(QString)), this, SLOT(appendMessage(QString)));
    connect(&client, SIGNAL(newParticipant(QString&)),     this, SLOT(newParticipant(QString&)));
    connect(&client, SIGNAL(participantLeft(QString&)),    this, SLOT(participantLeft(QString&)));

    QSettings *settings = new QSettings("WinT Messenger");
    color = settings->value("userColor", "#55aa7f").toString();
}

void LanChat::appendMessage(const QString &message) {
    newMessage(message, false);
}

void LanChat::returnPressed(QString text) {
    if (!text.isEmpty()) {
        QString formattedText = "<font color = '" + color + "'>"
                + "[" + QDateTime::currentDateTime().toString("hh:mm:ss") + "] "
                + "&lt;" + client.nickName() + "&gt;&nbsp; </font>"
                + text;

        client.sendMessage(formattedText);
        newMessage(formattedText, false);
    }
}

void LanChat::newParticipant(QString &nick) {
    nick.replace("<b>", "");
    nick.replace("</b>", "");
    newMessage(+ "[" + QDateTime::currentDateTime().toString("hh:mm:ss") + "] "
               + QString("%1 has joined.").arg(nick), true);
}

void LanChat::participantLeft(QString &nick) {
    nick.replace("<b>", "");
    nick.replace("</b>", "");
    newMessage(+ "[" + QDateTime::currentDateTime().toString("hh:mm:ss") + "] "
               + QString("%1 has left.").arg(nick), true);
}
