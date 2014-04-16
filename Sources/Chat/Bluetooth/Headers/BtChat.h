#ifndef BT_CHAT_H
#define BT_CHAT_H

#include "BtSelector.h"
#include "BtServer.h"
#include "BtClient.h"

#include <QDialog>
#include <QSettings>
#include <QBluetoothServiceInfo>
#include <QBluetoothSocket>
#include <QBluetoothHostInfo>

#include <QBluetoothUuid>
#include <QBluetoothServer>
#include <QBluetoothServiceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QBluetoothLocalDevice>

#include "../../../Common/Headers/MessageManager.h"

class BtChat : public QObject {

  Q_OBJECT

public:
  BtChat();
  ~BtChat();

signals:
  void sendMessage(const QString &text);
  void insertMessage(const QString &text);
  void newUser(const QString &nick);
  void delUser(const QString &nick);

public slots:
  void returnPressed(QString text);
  void shareFile();
  void showBtSelector();

private slots:
  void newParticipant(const QString &nick);
  void participantLeft(const QString &nick);

  void removeClients();
  void clientConnected(const QString &client);

private:
  BtServer *server;
  QString nickname;

  QList<BtClient *> clients;
  QList<QBluetoothHostInfo> localAdapters;
  int currentAdapterIndex;
};

#endif
