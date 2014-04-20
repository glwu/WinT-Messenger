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

static const QLatin1String serviceUuid("3185c780-c66e-11e3-8cde-0002a5d5c51b");

BtSelector::BtSelector(const QBluetoothAddress &localAdapter, QWidget *parent) : QDialog(parent), ui(new Ui::RemoteSelector) {
    ui->setupUi(this);

    discoveryAgent = new QBluetoothServiceDiscoveryAgent(localAdapter);

    connect(discoveryAgent, SIGNAL(serviceDiscovered(QBluetoothServiceInfo)), this, SLOT(serviceDiscovered(QBluetoothServiceInfo)));
    connect(discoveryAgent, SIGNAL(finished()), this, SLOT(discoveryFinished()));
    connect(discoveryAgent, SIGNAL(canceled()), this, SLOT(discoveryFinished()));

    connect(ui->stopButton,    SIGNAL(clicked()), this, SLOT(stopDiscovery()));
    connect(ui->refreshButton, SIGNAL(clicked()), this, SLOT(startDiscovery()));

    ui->busyAnimation->setMovie(new QMovie(":/images/Movies/Spinner.gif"));
    ui->busyAnimation->movie()->start();
    ui->busyAnimation->hide();

    ui->statusLabel->setText("Click \"Search\" to search for chat services");
    ui->refreshButton->setText("Search");
    ui->stopButton->setEnabled(false);
}

BtSelector::~BtSelector() {
    delete ui;
    delete discoveryAgent;
}

QBluetoothServiceInfo BtSelector::service() const {
    return m_service;
}

void BtSelector::startDiscovery() {
    ui->statusLabel->setText(tr("Scanning..."));
    ui->refreshButton->setText("Refresh");
    ui->stopButton->setEnabled(true);
    ui->busyAnimation->show();

    if (discoveryAgent->isActive())
        discoveryAgent->stop();

    ui->remoteDevices->clear();

    discoveryAgent->setUuidFilter(QBluetoothUuid(serviceUuid));
    discoveryAgent->start();
}

void BtSelector::stopDiscovery() {
    if (discoveryAgent) {
        discoveryAgent->stop();

        ui->statusLabel->setText("Click \"Search\" to search for chat services");
        ui->refreshButton->setText("Search");
        ui->stopButton->setEnabled(false);
        ui->busyAnimation->hide();
    }
}

void BtSelector::serviceDiscovered(const QBluetoothServiceInfo &serviceInfo) {
    QMapIterator<QListWidgetItem *, QBluetoothServiceInfo> _services(discoveredServices);

    while (_services.hasNext()) {
        _services.next();

        if (serviceInfo.device().address() == _services.value().device().address())
            return;
    }

    QString remoteName;
    if (serviceInfo.device().name().isEmpty())
        remoteName = serviceInfo.device().address().toString();

    else
        remoteName = serviceInfo.device().name();

    QListWidgetItem *item = new QListWidgetItem(QString::fromLatin1("%1 %2").arg(remoteName, serviceInfo.serviceName()));

    discoveredServices.insert(item, serviceInfo);
    ui->remoteDevices->addItem(item);
}

void BtSelector::discoveryFinished() {
    ui->statusLabel->setText(tr("Select the chat service to connect to"));
    stopDiscovery();
}

void BtSelector::on_remoteDevices_itemActivated(QListWidgetItem *item) {
    m_service = discoveredServices.value(item);
    accept();
}
