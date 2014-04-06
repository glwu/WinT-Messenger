//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Rectangle {
    id: button
    height : 1.9 * label.height
    width  : label.width > (6 * height) ? (1.5 * label.width) : (6 * height)

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

    opacity: 0.8
    border.color: colors.borderColor

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked   : button.clicked()
    }

    Text {
        id: label
        anchors.centerIn: parent
        font.pixelSize  : sizes.control
        font.family     : defaultFont
        color: {
            if (!button.enabled)
                return colors.buttonForegroundDisabled
            else
                return colors.buttonForeground
        }
    }
}
