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
    implicitHeight: device.ratio(16)
    property alias labelText: label.text
    implicitWidth: device.ratio(16) + label.width

    style: CheckBoxStyle {
        indicator: Rectangle {
            opacity: 0.8
            width: device.ratio(16)
            height: device.ratio(16)
            border.width: device.ratio(1)
            border.color: colors.borderColor

            Rectangle {
                anchors.fill: parent
                visible: control.checked
                color: colors.userColor
                anchors.margins: device.ratio(4)
            }
        }
    }

    Label {
        id: label
        color: colors.text
        x: device.ratio(20)
        font.family: global.font
        font.pixelSize: sizes.medium
        y: (control.height - height) / 2

        MouseArea {
            anchors.fill: parent
            onClicked: control.checked = !control.checked
        }
    }
}
