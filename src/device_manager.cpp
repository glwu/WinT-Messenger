//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "device_manager.h"

/*!
 * \brief DeviceManager::DeviceManager
 *
 * Initializes the \c DeviceManager and calculates the screen ratio
 */

DeviceManager::DeviceManager() {
    rect = qApp->primaryScreen()->geometry();
#if defined(Q_OS_ANDROID)
    screenRatio = 1.8 * qMin(qMax(rect.width(), rect.height())/1136. , qMin(rect.width(), rect.height())/640.);
#else
    screenRatio = 1.0;
#endif

}

/*!
 * \brief DeviceManager::isMobile
 * \return
 *
 * Returns \c true if detected operating system is one of the following:
 *  - Android
 *  - iOS
 *  - BlackBerry
 */

bool DeviceManager::isMobile() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return 1;
#endif
    return 0;
}

/*!
 * \brief DeviceManager::ratio
 * \param value
 * \return
 *
 * Returns the product of \c value and \c screenRatio.
 */

qreal DeviceManager::ratio(int value) {
    return value * screenRatio;
}
