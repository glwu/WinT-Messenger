//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2

Rectangle {
    id: button
    height : smartBorderSize(32)
    width  : smartBorderSize(192)

    signal clicked
    property alias text: label.text

    opacity: 0.9
    gradient: Gradient {
        GradientStop {
            position: 0
            color:{
                if (mouseArea.containsMouse)
                    return colors.buttonBackground1Hover
                else if (mouseArea.pressed)
                    return colors.buttonBackground1Pressed
                else if (!button.enabled)
                    return colors.buttonBackgroundDisabled
                else
                    return colors.buttonBackground1
            }
        }

        GradientStop {
            position: 1
            color:{
                if (mouseArea.containsMouse)
                    return colors.buttonBackground2Hover
                else if (mouseArea.pressed)
                    return colors.buttonBackground2Pressed
                else if (!button.enabled)
                    return colors.buttonBackgroundDisabled
                else
                    return colors.buttonBackground2
            }
        }
    }

    border.color: {
        if (mouseArea.containsMouse)
            return colors.borderColorHover
        else if (mouseArea.pressed)
            return colors.borderColorPressed
        else if (!button.enabled)
            return colors.borderColorDisabled
        else
            return colors.borderColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked   : button.clicked()
    }

    Text {
        id: label
        anchors.centerIn: parent
        font.pixelSize  : smartFontSize(12)
        font.family     : defaultFont
        color: {
            if (!button.enabled)
                return colors.buttonForegroundDisabled
            else
                return colors.buttonForeground
        }
    }
}
