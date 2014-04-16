#ifndef BRIDGE_H
#define BRIDGE_H

#include <QFileDialog>
#include <QMessageBox>

#include "MessageManager.h"
#include "DeviceManager.h"

#include "../../Chat/Network/Headers/NetChat.h"

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS) && !defined(Q_OS_BLACKBERRY)
#include "../../Chat/Bluetooth/Headers/BtChat.h"
#endif

class Bridge: public QWidget {

  Q_OBJECT

public:
  Bridge();
  ~Bridge();

  Q_INVOKABLE void attachFile();
  Q_INVOKABLE void sendMessage(QString text);

  Q_INVOKABLE void startNetChat();
  Q_INVOKABLE void stopNetChat();

  Q_INVOKABLE void startBtChat();
  Q_INVOKABLE void stopBtChat();
  Q_INVOKABLE void showBtSelector();

  Q_INVOKABLE void stopHotspot();
  Q_INVOKABLE void startHotspot(const QString &_ssid, const QString &_password);

  Q_INVOKABLE bool netChatEnabled();
  Q_INVOKABLE bool hotspotEnabled();
  Q_INVOKABLE bool btChatEnabled();

private slots:
  void processMessage(const QString &text);

signals:
  void newMessage(const QString &text);
  void returnPressed(const QString &text);
  void newUser(const QString &nick);
  void delUser(const QString &nick);

private:
  BtChat *btChat;
  NetChat *netChat;

  QList<NetChat*> netChatObjects;

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS) && !defined(Q_OS_BLACKBERRY)
  QList<BtChat*> btChatObjects;
#endif

  bool _btChatEnabled;
  bool _netChatEnabled;
  bool _netHotspot;

  int emotesSize;
};

#endif
