#include "bridge.h"

Bridge::Bridge() {
    emotes = new Emotes();
    lanChatEnabled = false;
}

void Bridge::startLanChat() {
    lanChat = new LanChat();
    QObject::connect(lanChat, SIGNAL(newMessage(QString, bool)), this, SLOT(processMessage(QString, bool)));
    QObject::connect(this,    SIGNAL(returnPressed(QString)), lanChat, SLOT(returnPressed(QString)));

    lanChatEnabled = true;
}

void Bridge::stopLanChat() {
    if (lanChatEnabled) {
        lanChat->deleteLater();
        lanChatEnabled = false;
    }
}

bool Bridge::hasConnection() {
    if (lanChatEnabled) {
        foreach (const QHostAddress &address, QNetworkInterface::allAddresses()) {
            if (address.protocol() == QAbstractSocket::IPv4Protocol
                    && address != QHostAddress(QHostAddress::LocalHost)
                    && address.toString().section( ".",-1,-1 ) != "1")
                return true;
        }
    }

    return false;
}

void Bridge::sendMessage(QString text) {
    returnPressed(text);
}

void Bridge::processMessage(const QString &text, bool info) {
    QString message = text;

    if (info)
        message = "<font color = 'blue'><samp>" + message + "</samp></font>";

    newMessage(emotes->addEmotes(message));
}
