//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../controls"
import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    opacity: 0
    height: units.gu(2.5)
    width: _label.text === "" ? height :
                                Math.max(units.gu(10),
                                         _label.paintedWidth + 2 * units.gu(2))

    anchors {
        top: parent.top
        topMargin: units.gu(1.75)
        horizontalCenter: parent.horizontalCenter
    }

    Behavior on opacity {NumberAnimation{}}

    function show(string) {
        opacity = 0.75
        _timer.start()
        _label.text = string
    }

    function hide() {
        opacity = 0
    }

    RectangularGlow {
        opacity: 0.5
        glowRadius: units.gu(2)
        anchors.fill: _background
        color: settings.darkInterface() ? theme.shadow : theme.borderColor
    }

    Timer {
        id: _timer
        interval: 5000
        onTriggered: {
            if (!_mouseArea.containsMouse)
                hide()
            else
                restart()
        }
    }

    Frame {
        id: _background
        anchors.fill: parent
        radius: units.scale(1)
        color: theme.notificationBackground
        border.color: theme.notificationBorder

        Label {
            id: _label
            anchors.centerIn: parent
            color: theme.notificationText
        }

        MouseArea {
            id: _mouseArea
            onClicked: hide()
            anchors.fill: parent
            hoverEnabled: !app.mobileDevice
        }
    }
}
