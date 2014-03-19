#include "chat.h"

using namespace std;

LanChat::LanChat() {
    connect(&client, SIGNAL(newMessage(QString)),      this, SLOT(appendMessage(QString)));
    connect(&client, SIGNAL(newParticipant(QString)),  this, SLOT(newParticipant(QString)));
    connect(&client, SIGNAL(participantLeft(QString)), this, SLOT(participantLeft(QString)));

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

void LanChat::newParticipant(const QString &nick) {
    if (!nick.isEmpty()) {
        QString formattedText = QString("<i><font color = 'gray'>%1 has joined</font></i>").arg(nick);

        formattedText.replace("<b>", NULL);
        formattedText.replace("</b>", NULL);

        newMessage(formattedText);
    }
}

void LanChat::participantLeft(const QString &nick) {
    if (!nick.isEmpty()) {
        QString formattedText = QString("<i><font color = 'gray'>%1 has left</font></i>").arg(nick);

        formattedText.replace("<b>", NULL);
        formattedText.replace("</b>", NULL);

        newMessage(formattedText);
    }
}
