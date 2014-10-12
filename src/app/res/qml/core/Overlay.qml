//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
    opacity: 0
    id: _overlay
    anchors.fill: parent
    color: Qt.rgba(0,0,0,0.4)
    Behavior on opacity {NumberAnimation{}}

    signal opened()
    property int openDialogs: 0

    function open() {
        opacity =  1
        openDialogs += 1
        opened()
    }

    function close() {
        openDialogs -= 1

        if (openDialogs <= 0)
            opacity = 0
    }

    MouseArea {
        anchors.fill: parent
        enabled: parent.opacity > 0
    }
}
