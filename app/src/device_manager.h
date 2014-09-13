//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
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

/*!
 * \class DeviceManager
 *
 * The DeviceManager class allows us to:
 *     - Know if the target operating system is
 *       a mobile OS or a desktop OS.
 *     - Resize the QML interface to fit inside
 *       the current display.
 */

class DeviceManager : public QObject
{
        Q_OBJECT

    public:
        DeviceManager();

        /// Returns \c true if current target is considered
        /// as an mobile operating system
        Q_INVOKABLE bool isMobile();

        /// Multiplies the input value to fit the device's
        /// screen configuration. This function is used
        /// to automaically adapt the QML interface
        Q_INVOKABLE qreal ratio (int value);

    private:
        QRect m_rect;
        double m_ratio;
};

#endif
