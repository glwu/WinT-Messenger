//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "device_manager.h"

bool DeviceManager::isMobile() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return 1;
#endif
    return 0;
}

qreal DeviceManager::ratio(int value) {
    double screenRatio = 1;

#if defined(Q_OS_ANDROID)
    screenRatio = 1.8 * qMin(qMax(rect.width(), rect.height())/1136. , qMin(rect.width(), rect.height())/640.);
#elif defined(Q_OS_IOS)
    screenRatio = 1.2;
#endif

    return value * screenRatio;
}
