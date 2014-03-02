//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

TextField {
    id: textField
    font.family    : defaultFont
    style          : textFieldStyle
    height         : smartBorderSize(32)
    font.pixelSize : smartFontSize(12)
    antialiasing   : true
    smooth         : true

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

            background:  BorderImage {
                border.bottom: smartBorderSize(8)
                border.top: smartBorderSize(8)
                border.right: smartBorderSize(8)
                border.left: smartBorderSize(8)

                source: {
                    if (mouseArea.containsMouse || textField.focus)
                        return controlPath + "FrameFocus.png"
                    else
                        return controlPath + "Frame.png"
                }

                width: parent.width
                height: parent.height

            }
        }
    }
}
