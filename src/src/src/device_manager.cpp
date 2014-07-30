//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "device_manager.h"

/// Initilizes and configures the \c DeviceManager class
DeviceManager::DeviceManager() {
    // Android is a very tricky thing here, because there are many kinds of
    // devices and configurations. Adding to that, the system may report a much
    // more lower DPI than the real DPI.
    // In order to make the app 'touchable', we need to use the reported logical
    // DPI (using the physical DPI returns a NULL value under Android)
    // and calculate a constant based on the screen resolution.

    if (ANDROID) {
        // First of all, get the size of the screen.
        // We don't want to use qApp->primaryScreen() for all the calculations.
        rect = qApp->primaryScreen()->geometry();

        // Get the logical DPI of the screen
        qreal _dpi = qApp->primaryScreen()->logicalDotsPerInch();

        // Divide the longer part of the screen by the shorter part
        qreal _ratio = rect.width() > rect.height() ? rect.width() /
                                                      rect.height() :

                                                      rect.height() /
                                                      rect.width();

        // Multiply the _ratio by the qoutient between the largest side of the
        // screen and the difference between the sides of the screen.
        _ratio *= rect.width() > rect.height() ? rect.width() / (rect.width()
                                                 - rect.height()) :

                                                 rect.height() / (rect.height()
                                                 - rect.width());

        // Optimize the _ratio based on the DPI and the OS, we should really
        // find a better way to calculate this part....
        _dpi > 160 ? _ratio *= (_dpi * _dpi / 10 * 000) * 0.8 : _ratio *= 2.54;

        // Now we create a factor by multiplying the  ratio by the sum of the
        // screen height and widthand dividing the result by the DPI.
        qreal sizeFactor = (rect.width() + rect.height() * _ratio) / _dpi;

        // Finally, divide the dpi by the size factor and round the number
        // to two decimal places.
        screenRatio = floorf((_dpi / sizeFactor) * 100 + 0.5) / 100;

        // Avoid having a screen ratio smaller than 1.0
        screenRatio < 1.00 ? screenRatio = 1.0 : screenRatio += 0;
    }

    // Other operating systems do not need to apply a hack like the one found
    // above in order to display WinT Messenger correctly.
    // So we scale the interface to 1:1.
    // Most systems, such as iOS will report a logical DPI of 72, and will
    // handle all the scaling code using their own methods, so scaling
    // the interface would only create a window of oportunity for obtaining
    // a screwed display...
    else
      screenRatio = 1.0;
}

/// Returns \c true if the detected operating system is a mobile operating system.
bool DeviceManager::isMobile() {
    // Return the pre-defined value generated during the compilation process
    return MOBILE_TARGET;
}

/// Returns the product of \c value and \c screenRatio.
/// \param value the value to "optimize" for the display
qreal DeviceManager::ratio(int value) {
    // Multiply the input value by the calculated screen ratio
    return value * screenRatio;
}
