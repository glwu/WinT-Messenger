//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

TextField {
    id: textField
    font.family    : defaultFont
    style          : textFieldStyle
    height         : 1.5 * smartSize(font.pointSize)
    antialiasing   : true
    font.pointSize : isMobile ? 12 : 8

    opacity: 0.8

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            parent.forceActiveFocus()
            Qt.inputMethod.show()
        }
    }

    Component {
        id: textFieldStyle

        TextFieldStyle {
            textColor            : colors.textFieldForeground
            placeholderTextColor : colors.textFieldPlaceholder

            background: Rectangle {
                color: textField.enabled ? colors.textFieldBackground : colors.buttonBackgroundDisabled

                border.color: {
                    if (mouseArea.containsMouse || textField.focus)
                        return colors.borderColorHover
                    else
                        return colors.borderColor
                }
            }

        }
    }
}
