#ifndef BT_SELECTOR_H
#define BT_SELECTOR_H

#include <QDialog>
#include <QBluetoothUuid>
#include <QBluetoothAddress>
#include <QBluetoothDeviceInfo>
#include <QBluetoothServiceInfo>
#include <QBluetoothLocalDevice>
#include <QBluetoothServiceDiscoveryAgent>

QT_FORWARD_DECLARE_CLASS(QModelIndex)
QT_FORWARD_DECLARE_CLASS(QListWidgetItem)

#include "ui_remoteselector.h"

QT_BEGIN_NAMESPACE
namespace Ui {class BtSelector;}
QT_END_NAMESPACE

class BtSelector : public QDialog {

  Q_OBJECT

public:
  explicit BtSelector(const QBluetoothAddress &localAdapter, QWidget *parent = 0);
  ~BtSelector();

  void startDiscovery(const QBluetoothUuid &uuid);
  void stopDiscovery();
  QBluetoothServiceInfo service() const;

private:
  Ui::RemoteSelector *ui;

  QBluetoothServiceDiscoveryAgent *m_discoveryAgent;
  QBluetoothServiceInfo m_service;
  QMap<QListWidgetItem *, QBluetoothServiceInfo> m_discoveredServices;

private slots:
  void serviceDiscovered(const QBluetoothServiceInfo &serviceInfo);
  void discoveryFinished();
  void on_remoteDevices_itemActivated(QListWidgetItem *item);
  void on_cancelButton_clicked();
};

#endif
