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

//============================================================================//
//Why the heck does this class exist?                                         //
//----------------------------------------------------------------------------//
//This class is in charge to tell the program if the device is mobile or not, //
//Also, this class resizes UI elements depending on the device's screen ratio.//
//============================================================================//

class DeviceManager : public QObject {

    Q_OBJECT

public:
    Q_INVOKABLE bool isMobile();
    Q_INVOKABLE int ratio(int value);
};

#endif
