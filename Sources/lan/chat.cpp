#include "chat.h"

using namespace std;

LanChat::LanChat() {
    connect(&client, SIGNAL(newMessage(QString,QString)), this, SLOT(appendMessage(QString,QString)));
    connect(&client, SIGNAL(newParticipant(QString&)),     this, SLOT(newParticipant(QString&)));
    connect(&client, SIGNAL(participantLeft(QString&)),    this, SLOT(participantLeft(QString&)));
}

void LanChat::appendMessage(const QString &from, const QString &message) {
    newMessage(from + ": " + message, false);
}

void LanChat::returnPressed(QString text) {
    if (!text.isEmpty()) {
        client.sendMessage(text);
        newMessage("<font color = 'purple'><b>You (" + client.nickName() + "):</b>&nbsp;" + text + "</font>", false);
    }
}

void LanChat::newParticipant(QString &nick) {
    nick.replace("<b>", "");
    nick.replace("</b>", "");
    newMessage(QString("%1 has joined.").arg(nick), true);
}

void LanChat::participantLeft(QString &nick) {
    nick.replace("<b>", "");
    nick.replace("</b>", "");
    newMessage(QString("%1 has left.").arg(nick), true);
}
