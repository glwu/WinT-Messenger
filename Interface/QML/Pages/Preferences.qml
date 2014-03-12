//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.1
import "../Widgets"

Page {
    logoImageSource : "qrc:/images/Settings.png"
    logoSubtitle    : qsTr("Customize WinT IM")
    logoTitle       : qsTr("Settings")
    toolbarTitle    : qsTr("Settings")

    property int perfectY: 10 + parent.height / 16 + 25

    Component.onCompleted: enableAboutButton(false)
    onVisibleChanged: enableAboutButton(!visible)

    Column {
        spacing: 8
        y: arrangeFirstItem
        anchors.left        : parent.left
        anchors.right       : parent.right
        anchors.leftMargin  : 48
        anchors.rightMargin : 48

        Label {
            anchors.left : parent.left
            text         : qsTr("Nickname and profile color:")
        }

        Rectangle {
            anchors.left  : parent.left
            anchors.right : parent.right

            height: textBox.height

            Textbox {
                id: textBox
                anchors.left    : parent.left
                anchors.right   : colorRectangle.left
                anchors.rightMargin: 2

                placeholderText : qsTr("Type a nickname and choose a profile color")
                text            : settings.value("userName", "unknown")
            }

            Rectangle {
                id: colorRectangle
                anchors.right: parent.right

                height: textBox.height
                width : height
                border.width: 1

                color: colorDialog.color
                border.color: colors.border

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked   : colorDialog.open()
                }
            }
        }

        ColorDialog {
            id: colorDialog
            title      : qsTr("Chose profile color")
            color      : settings.value("userColor", "#55aa7f")
            onAccepted : settings.setValue("userColor", color)
        }

        CheckBox {
            id: checkbox
            x: textBox.x
            checked: settings.value("mobileOptimized", isMobile)
            onCheckedChanged: settings.setValue("mobileOptimized", checked)
            text: qsTr("Optimize interface for touch")
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            y: perfectY
            text: qsTr("Apply")

            onClicked: {
                settings.setValue("mobileOptimized", checkbox.checked)
                settings.setValue("userColor", colorDialog.color)
                settings.setValue("userName", textBox.text)
                stackView.pop()
            }
        }
    }
}
