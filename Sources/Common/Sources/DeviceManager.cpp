//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//


#include "../Headers/DeviceManager.h"

int DeviceManager::ratio(int input) {
    double multiplicationRatio = 1;
    double deviceRatio = 1;

#if defined(Q_OS_ANDROID)
    multiplicationRatio = 1.8;
    deviceRatio = qMin(qMax(qApp->primaryScreen()->geometry().width(),
                            qApp->primaryScreen()->geometry().height()) / 1136.,
                       qMin(qApp->primaryScreen()->geometry().width(),
                            qApp->primaryScreen()->geometry().height()) / 640.);
#elif defined(Q_OS_IOS)
    multiplicationRatio = 1.2;
#endif

    return input * multiplicationRatio * deviceRatio;
}
