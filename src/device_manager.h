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
#include <QGuiApplication>

/// The following code will be used to
/// easily indentify the OS without using
/// preprocessor directives in the rest of
/// the program.

/// First of all, define all systems as false
/// so that we won't need to define them again
/// in each #if defined(...)

#define IOS false
#define LINUX false
#define ANDROID false
#define WINDOWS false
#define MAC_OS_X false
#define BLACKBERRY false

/// Define the defined OS as true, we need to undefine
/// the macro before assigning a new value to avoid
/// compilation warnings.

/// iOS
#if defined(Q_OS_IOS)
#undef IOS
#define IOS true

/// Linux
#elif defined(Q_OS_LINUX)
#undef LINUX
#define LINUX true

/// Android
#elif defined(Q_OS_ANDROID)
#undef ANDROID
#define ANDROID true

/// Windows
#elif defined(Q_OS_WINDOWS)
#undef WINDOWS
#define WINDOWS true

/// Mac OS X
#elif defined(MAC_OS_X)
#undef MAC_OS_X
#define MAC_OS_X true

/// BlackBerry
#elif defined(Q_OS_BLACKBERRY)
#undef BLACKBERRY
#define BLACKBERRY true
#endif

/// Define the MOBILE_TARGET macro
#if (ANDROID || IOS || BLACKBERRY)
#define MOBILE_TARGET true
#else
#define MOBILE_TARGET false
#endif

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
