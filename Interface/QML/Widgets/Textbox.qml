//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

Item {
    height: DeviceManager.ratio(32)

    property alias text: textField.text
    property alias placeholderText: textField.placeholderText
    property alias length: textField.length
    property alias echoMode: textField.echoMode

    TextField {
        id: textField
        font.family: defaultFont
        style: textFieldStyle
        font.pixelSize: sizes.text
        anchors.fill: parent

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: parent.forceActiveFocus()
       }

        onActiveFocusChanged: activeFocus ? Qt.inputMethod.show() : Qt.inputMethod.hide()

        Component {
            id: textFieldStyle

            TextFieldStyle {
                textColor: colors.textFieldForeground
                placeholderTextColor: colors.textFieldPlaceholder

                background: Rectangle {
                    color: textField.enabled ? colors.textFieldBackground: colors.buttonBackgroundDisabled

                    border.color: {
                        if (mouseArea.containsMouse || textField.focus)
                            return colors.borderColor
                        else
                            return colors.borderColor
                   }
               }
           }
       }
   }
}
