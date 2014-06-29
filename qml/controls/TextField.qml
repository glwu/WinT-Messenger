//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

//------------------------------------------------------------------------------//
// This object is a modified implementation of a TextField, the only difference //
// between this implementation and a normal TextField is the style and the font //
//------------------------------------------------------------------------------//

Item {
    height: device.ratio(32)

    // Allow the programmer to assign values to the TextField
    property alias text: textField.text
    property alias length: textField.length
    property alias echoMode: textField.echoMode
    property alias placeholderText: textField.placeholderText

    // Create the actual text field and change its style
    TextField {
        id: textField
        anchors.fill: parent
        style: textFieldStyle
        font.family: global.font
        font.pixelSize: units.fontSize("small")

        // Integrate the text field's style with the rest of the app
        Component {
            id: textFieldStyle

            // Create a new modified TextFieldStyle
            TextFieldStyle {
                textColor: theme.textFieldForeground
                placeholderTextColor: theme.textFieldPlaceholder

                background: Rectangle {
                    border.width: device.ratio(1)
                    border.color: theme.borderColor
                    color: textField.enabled ? theme.textFieldBackground:
                                               theme.buttonBackgroundDisabled
                }
            }
        }
    }
}
