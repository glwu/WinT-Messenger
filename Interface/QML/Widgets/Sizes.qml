//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

QtObject {
    property int text: DeviceManager.ratio(12)
    property int title: DeviceManager.ratio(15)
    property int control: DeviceManager.ratio(12)
    property int subtitle: DeviceManager.ratio(13)
    property int smallText: DeviceManager.ratio(11)
    property int smallControl: DeviceManager.ratio(10)
    property int toolbarTitle: DeviceManager.ratio(22)
}
