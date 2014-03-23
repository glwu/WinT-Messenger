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
    logoImageSource   : "qrc:/images/Logo.png"
    logoSubtitle      : qsTr("Please type your nickname")
    logoTitle         : qsTr("Initial setup")
    toolbarTitle      : qsTr("Initial setup")

    Component.onCompleted: {
        enableAboutButton(false)
        enableSettingsButton(false)
    }

    Column {
        spacing: smartSize(8)
        y: arrangeFirstItem
        anchors.left        : parent.left
        anchors.right       : parent.right
        anchors.leftMargin  : 24
        anchors.rightMargin : 24

        Label {
            anchors.left : parent.left
            text         : qsTr("Choose a nickname and profile color:")
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right

            height: textBox.height

            Textbox {
                id: textBox

                anchors.left        : parent.left
                anchors.right       : colorRectangle.left
                anchors.rightMargin : 2

                placeholderText : qsTr("Type a nickname and choose a profile color")
            }

            Rectangle {
                id: colorRectangle
                anchors.right: parent.right

                height: textBox.height
                width : height
                border.width: 1

                color: colorDialog.color
                border.color: {
                    if (mouseArea.containsMouse)
                        return colors.borderColorHover
                    else if (mouseArea.pressed)
                        return colors.borderColorPressed
                    else
                        return colors.borderColor
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked   : colorDialog.open()
                }
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
        anchors.bottom           : parent.bottom
        anchors.bottomMargin     : 10 + parent.height / 16
        anchors.horizontalCenter : parent.horizontalCenter
        text                     : qsTr("Done")
        enabled                  : textBox.length > 0 ? 1 : 0
        onClicked                : {
            settings.setValue("userName", textBox.text)
            settings.setValue("userColor", colorDialog.color)
            settings.setValue("firstLaunch", false);
            colors.userColor = colorDialog.color

            Qt.inputMethod.hide()
            finishSetup(textBox.text)
        }
    }
}
