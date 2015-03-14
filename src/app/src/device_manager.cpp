//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  Please check the license.txt file for more information.
//

#include <qdebug.h>
#include "device_manager.h"

DeviceManager::DeviceManager()
{
    m_ratio = qApp->devicePixelRatio();
    qDebug() << m_ratio;
}

bool DeviceManager::isMobile()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return true;
#else
    return false;
#endif
}

qreal DeviceManager::ratio (int value)
{
    return value * m_ratio;
}
