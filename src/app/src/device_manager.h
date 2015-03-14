//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  Please check the license.txt file for more information.
//

#ifndef DEVICE_MANAGER_H
#define DEVICE_MANAGER_H

#include <math.h>

#include <QObject>
#include <QScreen>
#include <QApplication>

class DeviceManager : public QObject
{
        Q_OBJECT

    public:
        DeviceManager();

        Q_INVOKABLE bool isMobile();
        Q_INVOKABLE qreal ratio (int value);

    private:

        QRect m_rect;
        double m_ratio;
};

#endif
