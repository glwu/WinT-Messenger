//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "../Headers/Bridge.h"

Bridge::Bridge() {
    emotes = new Emotes();
    netChatEnabled = false;
    netHotspot = false;
}

void Bridge::attachFile() {
    if (netChatEnabled) {
#if !defined(Q_OS_ANDROID)
        netChat->sendFile(QFileDialog::getOpenFileName(NULL, tr("Open File"), QDir::homePath()));
#endif
        QMessageBox::warning(NULL, tr("Not supported"), tr("Sorry, file sharing is not supported yet"));
    }
}

void Bridge::sendMessage(QString text) {
    returnPressed(text);
}

void Bridge::startNetChat() {
    netChat = new NetChat();
    netChatEnabled = true;

    QObject::connect(netChat, SIGNAL(newMessage(QString)),    this,    SLOT(processMessage(QString)));
    QObject::connect(netChat, SIGNAL(newUser(QString)),       this,    SIGNAL(newUser(QString)));
    QObject::connect(netChat, SIGNAL(delUser(QString)),       this,    SIGNAL(delUser(QString)));
    QObject::connect(this,    SIGNAL(returnPressed(QString)), netChat, SLOT(returnPressed(QString)));
}

void Bridge::stopNetChat() {
    if (netChatEnabled) {
        netChat->deleteLater();
        netChatEnabled = false;
    }
}

void Bridge::startBtChat() {

}

void Bridge::stopBtChat() {

}

bool Bridge::hotspotEnabled() {
    return netHotspot;
}

void Bridge::stopHotspot() {
    if (hotspotEnabled()) {
#ifdef Q_OS_WIN
        ShellExecute(0, L"RUNAS", L"NETSH", L"WLAN STOP HOSTEDNETWORK", 0, SW_HIDE);

        stopNetChat();
        netHotspot = false;
        return;
#endif

#ifdef Q_OS_ANDROID
        /// FUNCTION TO STOP HOTSPOT

        stopNetChat();
        netHotspot = false;
        return;
#endif

#ifdef Q_OS_LINUX
        /// FUNCTION TO STOP HOTSPOT

        stopNetChat();
        netHotspot = false;
        return;
#endif

#ifdef Q_OS_MAC
        /// FUNCTION TO STOP HOTSPOT

        stopNetChat();
        netHotspot = false;
        return;
#endif

#ifdef Q_OS_IOS
        /// FUNCTION TO STOP HOTSPOT

        stopNetChat();
        netHotspot = false;
        return;
#endif
    }
}

void Bridge::startHotspot(const QString &_ssid, const QString &_password) {
#ifdef Q_OS_WIN
    ShellExecute(0, L"RUNAS", L"NETSH", QString("WLAN SET HOSTED NETWORK MODE=ALLOW SSID=%1 KEY=%2").arg(_ssid, _password).toStdWString().c_str(), 0, SW_HIDE);
    ShellExecute(0, L"RUNAS", L"NETSH", L"WLAN REFRESH HOSTEDNETWORK KEY", 0, SW_HIDE);
    ShellExecute(0, L"RUNAS", L"NETSH", L"WLAN START HOSTEDNETWORK",       0, SW_HIDE);

    startNetChat();

    netHotspot = true;
    return;
#endif

#ifdef Q_OS_ANDROID
#endif

#ifdef Q_OS_LINUX
#endif

#ifdef Q_OS_MAC
#endif

#ifdef Q_OS_IOS
#endif
}

void Bridge::processMessage(const QString &text) {
    newMessage(emotes->addEmotes(text, DeviceManager::ratio(16)));
}
