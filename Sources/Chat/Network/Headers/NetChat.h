#ifndef NET_CHAT_H
#define NET_CHAT_H

#include "NetClient.h"
#include "../../../Common/Headers/MessageManager.h"

class NetChat : public QObject {

  Q_OBJECT

public:
  NetChat();

signals:
  void newMessage(const QString &text);
  void newUser(const QString &nick);
  void delUser(const QString &nick);

public slots:
  void returnPressed(QString text);
  void shareFile();

private slots:
  void newParticipant(const QString &nick);
  void participantLeft(const QString &nick);

private:
  NetClient client;
};

#endif
