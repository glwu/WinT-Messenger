#ifndef BRIDGE_H
#define BRIDGE_H

#include <QObject>
#include <QHostInfo>
#include <QMessageBox>
#include <QApplication>

#ifdef Q_OS_WIN
#include <qt_windows.h>
#include <qwindowdefs_win.h>
#endif

#include "emotes.h"
#include "lan/chat.h"

class Bridge: public QWidget {

    Q_OBJECT

public:
    Bridge();

    // General functions
    Q_INVOKABLE void sendMessage(QString text);
    Q_INVOKABLE QString hostName();
    Q_INVOKABLE void setEmotesSize(int _size);

    // Lan chat functions
    Q_INVOKABLE void startLanChat();
    Q_INVOKABLE void stopLanChat();

    // Bluetooth functions
    Q_INVOKABLE void startBtChat();
    Q_INVOKABLE void stopBtChat();

    // Ad hoc chat functions
    Q_INVOKABLE bool adHocEnabled();
    Q_INVOKABLE void stopAdHoc();
    Q_INVOKABLE void startAdHoc(const QString &_ssid);

private slots:
    void processMessage(const QString &text);

signals:
    void newMessage(const QString &text);
    void returnPressed(const QString &text);

private:
    LanChat *lanChat;
    Emotes *emotes;

    bool lanChatEnabled;
    bool _adHocEnabled;
    int emotesSize;

    QString ssid;
};

#endif
