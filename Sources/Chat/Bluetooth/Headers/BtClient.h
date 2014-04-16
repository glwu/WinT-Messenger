#ifndef BT_CLIENT_H
#define BT_CLIENT_H

#include <QObject>
#include <QBluetoothSocket>
#include <QBluetoothServiceInfo>

QT_FORWARD_DECLARE_CLASS(QBluetoothSocket)

class BtClient : public QObject {
  Q_OBJECT

public:
  explicit BtClient(QObject *parent = 0);
  ~BtClient();

  void startClient(const QBluetoothServiceInfo &remoteService);
  void stopClient();

public slots:
  void sendMessage(const QString &message);

signals:
  void messageReceived(const QString &sender, const QString &message);
  void connected(const QString &name);
  void disconnected();

private slots:
  void readSocket();
  void connected();

private:
  QBluetoothSocket *socket;
};

#endif
