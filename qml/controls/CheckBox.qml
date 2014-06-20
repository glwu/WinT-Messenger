//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

CheckBox {
    id: control

    // Have a consistent size
    implicitHeight: device.ratio(16)
    implicitWidth: device.ratio(16) + label.width

    // Allow the programmer to change the caption of the check box
    property alias labelText: label.text

    // We change the style of the checkbox so that we can have a more
    // consisten user interface accross the application.
    style: CheckBoxStyle {
        indicator: Rectangle {

            // Be semi-transparent, like a button
            opacity: 0.8

            // Have a square check box
            width: device.ratio(16)
            height: device.ratio(16)

            // Set the border properties
            border.width: device.ratio(1)
            border.color: colors.borderColor

            // Show this rectangle when the checkbox is checked
            Rectangle {
                anchors.fill: parent
                visible: control.checked
                color: colors.userColor
                anchors.margins: device.ratio(4)
            }
        }
    }

    // We need to implement another label to make the size of the text
    // match the rest of the controls of the app.
    Text {
        id: label
        smooth: true
        color: colors.text
        antialiasing: true
        x: device.ratio(20)
        font.family: global.font
        font.pixelSize: sizes.medium
        y: (control.height - height) / 2

        // We use this mouse area to change the checked state of the checkbox
        // when the text is clicked (useful in touch environments).
        MouseArea {
            anchors.fill: parent
            onClicked: control.checked = !control.checked
        }
    }
}
