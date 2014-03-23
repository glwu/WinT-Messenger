//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import QtQuick.Dialogs 1.1
import "../Widgets"

Page {
    id: preferences

    logoImageSource : "qrc:/images/Settings.png"
    logoSubtitle    : qsTr("Customize WinT IM")
    logoTitle       : qsTr("Settings")
    toolbarTitle    : qsTr("Settings")

    Component.onCompleted: {
        enableAboutButton(false)
        enableSettingsButton(false)
    }

    onVisibleChanged: {
        enableAboutButton(!visible)
        enableSettingsButton(!visible)
    }

    Column {
        spacing: smartSize(8)
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

            color: colors.background

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
                border.color: colors.borderColor

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
            color      : settings.value("userColor", colors.userColor)
            onAccepted : {
                settings.setValue("userColor", color)
                colors.userColor = colorDialog.color
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 10 + preferences.height / 16
            text: qsTr("Apply")

            onClicked: {
                settings.setValue("userColor", colorDialog.color)
                settings.setValue("userName", textBox.text)

                colors.userColor = colorDialog.color
                stackView.pop()
            }
        }
    }
}
