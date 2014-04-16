/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtBluetooth module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "../Headers/BtSelector.h"

BtSelector::BtSelector(const QBluetoothAddress &localAdapter, QWidget *parent) : QDialog(parent), ui(new Ui::RemoteSelector) {
  ui->setupUi(this);

  m_discoveryAgent = new QBluetoothServiceDiscoveryAgent(localAdapter);

  connect(m_discoveryAgent, SIGNAL(serviceDiscovered(QBluetoothServiceInfo)),
          this, SLOT(serviceDiscovered(QBluetoothServiceInfo)));
  connect(m_discoveryAgent, SIGNAL(finished()), this, SLOT(discoveryFinished()));
  connect(m_discoveryAgent, SIGNAL(canceled()), this, SLOT(discoveryFinished()));
}

BtSelector::~BtSelector() {
  delete ui;
  delete m_discoveryAgent;
}

void BtSelector::startDiscovery(const QBluetoothUuid &uuid) {
  ui->status->setText(tr("Scanning..."));
  if (m_discoveryAgent->isActive())
    m_discoveryAgent->stop();

  ui->remoteDevices->clear();

  m_discoveryAgent->setUuidFilter(uuid);
  m_discoveryAgent->start();

}

void BtSelector::stopDiscovery() {
  if (m_discoveryAgent)
    m_discoveryAgent->stop();
}

QBluetoothServiceInfo BtSelector::service() const {
  return m_service;
}

void BtSelector::serviceDiscovered(const QBluetoothServiceInfo &serviceInfo) {
  QMapIterator<QListWidgetItem *, QBluetoothServiceInfo> i(m_discoveredServices);
  while (i.hasNext()) {
      i.next();

      if (serviceInfo.device().address() == i.value().device().address())
        return;
   }

  QString remoteName;
  if (serviceInfo.device().name().isEmpty())
    remoteName = serviceInfo.device().address().toString();

  else
    remoteName = serviceInfo.device().name();

  QListWidgetItem *item = new QListWidgetItem(QString::fromLatin1("%1 %2").arg(remoteName, serviceInfo.serviceName()));

  m_discoveredServices.insert(item, serviceInfo);
  ui->remoteDevices->addItem(item);
}

void BtSelector::discoveryFinished() {
  ui->status->setText(tr("Select the chat service to connect to."));
}

void BtSelector::on_remoteDevices_itemActivated(QListWidgetItem *item) {
  m_service = m_discoveredServices.value(item);

  accept();
}

void BtSelector::on_cancelButton_clicked() {
  reject();
}
