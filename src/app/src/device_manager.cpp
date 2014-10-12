//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "device_manager.h"

DeviceManager::DeviceManager()
{
    if (ANDROID)
    {
        QRect _screen = qApp->primaryScreen()->geometry();
        m_ratio = 1.8 * qMin (qMax (_screen.width(), _screen.height()) / 1136.,
                              qMin (_screen.width(), _screen.height()) / 640.);
    }

    else
        m_ratio = 1.0;
}

bool DeviceManager::isMobile()
{
    return MOBILE_TARGET;
}

qreal DeviceManager::ratio (int value)
{
    return value * m_ratio;
}
