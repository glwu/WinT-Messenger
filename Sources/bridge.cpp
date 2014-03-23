#include "bridge.h"

Bridge::Bridge() {
    emotes = new Emotes();
    lanChatEnabled = false;
}

void Bridge::sendMessage(QString text) {
    returnPressed(text);
}

QString Bridge::hostName() {
    return QHostInfo::localHostName();
}

void Bridge::setEmotesSize(int _size) {
    emotesSize = _size;
}

void Bridge::startLanChat() {
    lanChat = new LanChat();
    QObject::connect(lanChat, SIGNAL(newMessage(QString)),    this, SLOT(processMessage(QString)));
    QObject::connect(this,    SIGNAL(returnPressed(QString)), lanChat, SLOT(returnPressed(QString)));

    lanChatEnabled = true;
    _adHocEnabled = false;
}

void Bridge::stopLanChat() {
    if (lanChatEnabled) {
        lanChat->deleteLater();
        lanChatEnabled = false;
    }
}

void Bridge::startBtChat() {

}

void Bridge::stopBtChat() {

}

bool Bridge::adHocEnabled() {
    return _adHocEnabled;
}

void Bridge::stopAdHoc() {
    if (adHocEnabled()) {
#ifdef Q_OS_WIN
        ShellExecute(NULL, L"RUNAS", L"NETSH", L"WLAN STOP HOSTEDNETWORK", NULL, SW_HIDE);
        _adHocEnabled = false;
        return;
#endif
    }
}

void Bridge::startAdHoc(const QString &_ssid) {
#ifdef Q_OS_WIN
    ShellExecute(NULL, L"RUNAS", L"NETSH", QString("WLAN SET HOSTED NETWORK MODE=ALLOW SSID=\"%1\" KEY=\"\"").arg(_ssid).toStdWString().c_str(), NULL, SW_HIDE);
    ShellExecute(NULL, L"RUNAS", L"NETSH", L"WLAN REFRESH HOSTEDNETWORK KEY", NULL, SW_HIDE);
    ShellExecute(NULL, L"RUNAS", L"NETSH", L"WLAN START HOSTEDNETWORK",       NULL, SW_HIDE);

    ssid = _ssid;
    _adHocEnabled = true;
    return;
#endif

    _adHocEnabled = false;
    QMessageBox::warning(this, tr("OS not supported"), tr("Cannot create network %1 because your OS is not supported.").arg(_ssid));
}

void Bridge::processMessage(const QString &text) {
    newMessage(emotes->addEmotes(text, emotesSize));
}
