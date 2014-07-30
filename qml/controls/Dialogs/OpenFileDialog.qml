//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../Core"
import QtQuick 2.2

Sheet {
    id: sheet
    title: "Open File"
    margins: units.gu(1)
    buttonsEnabled: false

    Item {
        id: controls
        width: parent.width
        height: upButton.height

        Button {
            id: upButton
            rotation: 180
            iconName: "chevron-down"
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }

        Button {
            id: downButton
            iconName: "chevron-down"
            anchors {
                left: upButton.right
                leftMargin: device.ratio(-1)
                verticalCenter: parent.verticalCenter
            }
        }

        TextField {
            anchors {
                right: parent.right
                left: downButton.right
                leftMargin: units.gu(1)
                verticalCenter: parent.verticalCenter
            }
        }
    }

    Rectangle {
        color: theme.panel
        anchors.fill: parent
        radius: units.gu(0.5)
        border.width: device.ratio(1)
        border.color: theme.borderColor
        anchors.topMargin: controls.height + units.gu(1)
        anchors.bottomMargin: rectangle.height + units.gu(1)

        Label {
            anchors.centerIn: parent
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: qsTr("Work in progress! Tap me to open a dialog!")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: bridge.shareFiles()
        }
    }

    Rectangle {
        id: rectangle
        color: "transparent"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: openButton.height * 1.2

        Row {
            spacing: units.gu(1)
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            Button {
                text: "Cancel"
                id: cancelButton
                onClicked: sheet.close()
                anchors.verticalCenter: parent.verticalCenter
            }

            Button {
                text: "Open"
                id: openButton
                primary: true
                onClicked: accepted()
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
