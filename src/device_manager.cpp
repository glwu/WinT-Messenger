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
#ifdef Q_OS_ANDROID
    // Android is a very tricky thing here, because there are many kinds of devices
    // and configurations.

    // Get the size of the screen
    rect = qApp->primaryScreen()->geometry();

    // Get the DPI of the screen
    qreal _dpi = qApp->primaryScreen()->logicalDotsPerInch();

    // Divide the longer part of the screen by the shorter part
    qreal _ratio = rect.width() > rect.height() ? rect.width() / rect.height() :
                                                  rect.height() / rect.width();

    // Multiply the ratio by the inverted fractional difference between the height and width
    // of the display.
    _ratio *= rect.width() > rect.height() ? rect.width() / (rect.width() - rect.height()) :
                                             rect.height() / (rect.height() - rect.width());

    // Optimize the _ratio based on the DPI and the OS
    if (_dpi >= 160)
        _ratio *= (_dpi / 100) * (_dpi / 100) * 0.8;
    else
        _ratio *= 2.54;

    // Now we create a factor by multiplying the  ratio by the sum of the screen height and width
    // and dividing the result by the dpi.
    qreal sizeFactor = (rect.width() + rect.height() * _ratio) / _dpi;

    // Finally, divide the dpi by the size factor and round the number
    // to two decimal places.
    screenRatio = floorf((_dpi / sizeFactor) * 100 + 0.5) / 100;

    // Avoid having a screen ratio smaller than 1.0
    screenRatio < 1.00 ? screenRatio = 1.0 : screenRatio += 0;
#else
    // Other operating systems do not need all this hack in order to display
    // WinT Messenger correctly. So we scale the interface to 1:1
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
    return MOBILE_TARGET;
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
