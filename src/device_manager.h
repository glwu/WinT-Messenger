//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#ifndef DEVICE_MANAGER_H
#define DEVICE_MANAGER_H

#include <QObject>
#include <QScreen>
#include <QGuiApplication>

class DeviceManager : public QObject {

    Q_OBJECT

public:
    DeviceManager();

    Q_INVOKABLE bool isMobile();
    Q_INVOKABLE qreal ratio(int value);

private:
    QRect rect;
    double screenRatio;
};

#endif
