//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property alias source: _image.source

    Image {
        id: _image
        cache: false
        smooth: true
        visible: false
        asynchronous: true
        anchors.fill: parent
        sourceSize: Qt.size(width, height)
    }

    Rectangle {
        id: _mask
        color: "black"
        visible: false
        radius: width / 2
        width: _image.width
        height: _image.height
        anchors.centerIn: _image
    }

    OpacityMask {
        source: _image
        maskSource: _mask
        width: _image.width
        height: _image.height
        anchors.centerIn: _image
    }
}
