//
//  This file is part of Leaf Tips
//
//  Copyright (c) 2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
    id: button
    opacity: 0.85
    color: colors.buttonBackground
    height: 1.9 * label.height
    border.color: colors.borderColor
    width: label.width > (6 * height) ? (1.5 * label.width) : (6 * height)

    signal clicked
    property bool checked: false
    property bool checkable: false
    property alias text: label.text

    Rectangle {
        anchors.fill: parent
        border.color: mouseArea.containsMouse || mouseArea.pressed ? colors.userColor : colors.borderColor
        color: {
            if (checked)
                return colors.userColor
            else if (mouseArea.containsMouse || mouseArea.pressed)
                return colors.userColor
            else if (!button.enabled)
                return colors.buttonBackgroundDisabled
            else
                return colors.buttonBackground
        }

        opacity: mouseArea.pressed ? 0.2 : 0.1
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: !device.isMobile()
        onClicked: {
            if (checkable)
                checked = !checked
            button.clicked()
        }
    }

    Label {
        id: label
        anchors.centerIn: parent
        color: parent.enabled ? colors.buttonForeground : colors.buttonForegroundDisabled
    }
}
