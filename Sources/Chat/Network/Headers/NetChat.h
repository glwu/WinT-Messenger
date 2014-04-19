#ifndef NET_CHAT_H
#define NET_CHAT_H

#include <QFile>
#include <QSettings>
#include <QFileDialog>
#include <QDesktopServices>

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
  void returnPressed(const QString &text);
  void shareFile(const QString &fileName);

private slots:
  void newParticipant(const QString &nick);
  void participantLeft(const QString &nick);
  void receivedFile(const QByteArray &data, const QString &fileName);

private:
  NetClient client;
};

#endif
