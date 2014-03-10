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
    height         : smartBorderSize(32)
    antialiasing   : true
    font.pixelSize : smartFontSize(12)

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
                color: "white"

                border.color: {
                    if (mouseArea.containsMouse || textField.focus)
                        return settings.value("userColor", "#55aa7f")
                    else
                        return colors.border
                }
            }

        }
    }
}
