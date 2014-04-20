//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
    id: button
    opacity: 0.8
    height: 1.9 * label.height
    border.color: colors.borderColor
    width: label.width > (6 * height) ? (1.5 * label.width): (6 * height)

    signal clicked
    property alias text: label.text

    color: {
        if (mouseArea.containsMouse && !mouseArea.pressed)
            return colors.buttonBackgroundHover
        else if (mouseArea.pressed)
            return colors.buttonBackgroundPressed
        else if (!button.enabled)
            return colors.buttonBackgroundDisabled
        else
            return colors.buttonBackground
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        onClicked: button.clicked()
    }

    Label {
        id: label
        anchors.centerIn: parent
        color: parent.enabled ? colors.buttonForeground : colors.buttonForegroundDisabled
    }
}
