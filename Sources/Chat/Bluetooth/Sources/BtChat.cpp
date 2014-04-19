//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "../Headers/BtChat.h"

BtChat::BtChat(){
  localAdapters = QBluetoothLocalDevice::allDevices();

  if (localAdapters.count() > 2) {
      QBluetoothLocalDevice adapter(localAdapters.at(0).address());
      adapter.setHostMode(QBluetoothLocalDevice::HostDiscoverable);
    }

  server = new BtServer(this);
  connect(server, SIGNAL(clientConnected(QString)),    this, SLOT(newParticipant(QString)));
  connect(server, SIGNAL(clientDisconnected(QString)), this, SLOT(participantLeft(QString)));
  connect(server, SIGNAL(messageReceived(QString)),    this, SIGNAL(insertMessage(QString)));

  QSettings settings("WinT Messenger");
  nickname = settings.value("userName", "unknown").toString();
}

BtChat::~BtChat() {
  qDeleteAll(clients);
  delete server;
}

void BtChat::returnPressed(const QString text) {
  emit insertMessage(MessageManager::formatMessage(text, nickname));
  emit sendMessage(MessageManager::formatMessage(text, nickname));
  server->sendMessage(MessageManager::formatMessage(text, nickname));
}

void BtChat::shareFile(const QString fileName) {
  /*QBluetoothTransferManager mgr;
  QBluetoothTransferRequest req(m_service.device().address());

  m_file = new QFile(ui->fileName->text());

  Progress *p = new Progress;
  p->setStatus("Sending to: " + m_service.device().name(), "Waiting for start");
  p->show();

  QBluetoothTransferReply *reply = mgr.put(req, m_file);
  //mgr is default parent
  //ensure that mgr doesn't take reply down when leaving scope
  reply->setParent(this);
  if (reply->error()){
      qDebug() << "Failed to send file";
      p->finished(reply);
      reply->deleteLater();
      return;
  }

  connect(reply, SIGNAL(transferProgress(qint64,qint64)), p, SLOT(uploadProgress(qint64,qint64)));
  connect(reply, SIGNAL(finished(QBluetoothTransferReply*)), p, SLOT(finished(QBluetoothTransferReply*)));
  connect(p, SIGNAL(rejected()), reply, SLOT(abort()));*/
}

void BtChat::showBtSelector() {
  const QBluetoothAddress adapter = QBluetoothAddress();
  BtSelector *selector = new BtSelector(adapter);
  selector->startDiscovery();

  if (selector->exec() == QDialog::Accepted) {
      QBluetoothServiceInfo service = selector->service();

      BtClient *client = new BtClient(this);
      connect(client, SIGNAL(messageReceived(QString)), this,   SIGNAL(insertMessage(QString)));
      connect(client, SIGNAL(disconnected()),           this,   SLOT(removeClients()));
      connect(client, SIGNAL(connected(QString)),       this,   SLOT(clientConnected(QString)));
      connect(this,   SIGNAL(sendMessage(QString)),     client, SLOT(sendMessage(QString)));

      client->startClient(service);
      clients.append(client);
    }

  else
    selector->close();
}

void BtChat::newParticipant(const QString &nick) {
  emit insertMessage(MessageManager::formatNotification("%1 has joined").arg(nick));
}

void BtChat::participantLeft(const QString &nick) {
  emit insertMessage(MessageManager::formatNotification("%1 has left").arg(nick));
}

void BtChat::removeClients() {
  BtClient *client = qobject_cast<BtClient *>(sender());
  if (client) {
      clients.removeOne(client);
      client->deleteLater();
    }
}

void BtChat::clientConnected(const QString &client) {
  emit insertMessage(MessageManager::formatNotification("Joined chat with %1").arg(client));
}
