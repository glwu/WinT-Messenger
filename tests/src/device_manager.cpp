//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include <QDebug>
#include "device_manager.h"

//===========================================================================//
//The following functions are used by the QML interface to make decicions and//
//resize the UI to match the device's screen (this applies mostly to Android)//
//===========================================================================//

bool DeviceManager::isMobile() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return 1;
#endif
    return 0;
}

int DeviceManager::ratio(int value) {
    double multiplicationRatio = 1;
    double screenRatio = qMin(qMax(qApp->primaryScreen()->geometry().width(),
                                   qApp->primaryScreen()->geometry().height())
                              / 1136.,
                              qMin(qApp->primaryScreen()->geometry().width(),
                                   qApp->primaryScreen()->geometry().height())
                              / 640.);

#if defined(Q_OS_ANDROID)
    multiplicationRatio = 1.8;
#endif

    return value * screenRatio * multiplicationRatio;
}
