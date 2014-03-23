//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2

Rectangle {
    id: button
    height : 2.1 * label.height
    width  : label.width > (5 * height) ? (1.5 * label.width) : (5 * height)

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
        font.pointSize  : isMobile ? 12 : 8
        font.family     : defaultFont
        color: {
            if (!button.enabled)
                return colors.buttonForegroundDisabled
            else
                return colors.buttonForeground
        }
    }
}
