//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef DEVICE_MANAGER_H
#define DEVICE_MANAGER_H

#include <math.h>

#include <QObject>
#include <QScreen>
#include <QApplication>

#include "platforms.h"

class DeviceManager : public QObject {
    Q_OBJECT

  public:

    DeviceManager();

    /// Returns \c true if target operating system
    /// is Android, iOS or BlackBerry
    Q_INVOKABLE bool isMobile();

    /// Multiplies input value by a calculated
    /// constant based on the screen's resolution
    Q_INVOKABLE qreal ratio (int value);

  private:

    QRect m_rect;
    double m_ratio;
};

#endif
