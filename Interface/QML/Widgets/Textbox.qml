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
    property alias length: textField.length
    property alias echoMode: textField.echoMode
    property alias placeholderText: textField.placeholderText

    TextField {
        id: textField
        anchors.fill: parent
        style: textFieldStyle
        font {family: defaultFont; pixelSize: sizes.text;}
        onActiveFocusChanged: activeFocus ? Qt.inputMethod.show() : Qt.inputMethod.hide()

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
            onClicked: parent.forceActiveFocus()
        }

        Component {
            id: textFieldStyle

            TextFieldStyle {
                textColor: colors.textFieldForeground
                placeholderTextColor: colors.textFieldPlaceholder

                background: Rectangle {
                    border.color: colors.borderColor
                    color: textField.enabled ? colors.textFieldBackground: colors.buttonBackgroundDisabled
                }
            }
        }
    }
}
