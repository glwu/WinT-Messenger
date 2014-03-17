#include "bridge.h"

Bridge::Bridge() {
    emotes = new Emotes();
    lanChatEnabled = false;
}

void Bridge::startLanChat() {
    lanChat = new LanChat();
    QObject::connect(lanChat, SIGNAL(newMessage(QString)),    this, SLOT(processMessage(QString)));
    QObject::connect(this,    SIGNAL(returnPressed(QString)), lanChat, SLOT(returnPressed(QString)));

    lanChatEnabled = true;
}

void Bridge::stopLanChat() {
    if (lanChatEnabled) {
        lanChat->deleteLater();
        lanChatEnabled = false;
    }
}

void Bridge::sendMessage(QString text) {
    returnPressed(text);
}

void Bridge::processMessage(const QString &text) {
    newMessage(emotes->addEmotes(text));
}
