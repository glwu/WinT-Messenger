#ifndef CHAT_H
#define CHAT_H

#include <QColor>
#include <QSettings>

#include "client.h"

class LanChat : public QObject {

    Q_OBJECT

public:
    LanChat();

signals:
    void newMessage(const QString &text);

public slots:
    void returnPressed(QString text);

private slots:
    void appendMessage(const QString &message);

private:
    Client client;
    QString color;
};

#endif
