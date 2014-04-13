//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.1
import "../Widgets"

Page {
    logoImageSource: "qrc:/images/Logo.png"
    logoSubtitle: qsTr("Customize your setup")
    logoTitle: qsTr("Initial setup")
    toolbarTitle: qsTr("Initial setup")

    Component.onCompleted: {
        enableAboutButton(false)
        enableSettingsButton(false)
    }

    Column {
        spacing: DeviceManager.ratio(8)
        y: arrangeFirstItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 24
        anchors.rightMargin: 24

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: textBox.height

            Textbox {
                id: textBox
                anchors.left: parent.left
                anchors.right: colorRectangle.left
                anchors.rightMargin: 2
                placeholderText: qsTr("Type a nickname and choose a profile color")
            }

            Rectangle {
                id: colorRectangle
                anchors.right: parent.right
                height: textBox.height
                width: height
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

                onColorChanged: {
                    Settings.setValue("userColor", colorDialog.color)
                    colors.userColor = colorDialog.color

                    if (Settings.customizedUiColor())
                        colors.toolbarColor = colors.userColor
                    else
                        colors.toolbarColor = colors.toolbarColorStatic
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: colorDialog.open()
                }
            }
        }

        CheckBox {
            id: customizedUiColor
            checked: Settings.customizedUiColor()
            onCheckedChanged: {
                Settings.setValue("customizedUiColor", checked)

                if (Settings.customizedUiColor())
                    colors.toolbarColor = colors.userColor
                else
                    colors.toolbarColor = colors.toolbarColorStatic
            }

            Label {
                anchors.left: customizedUiColor.right
                text: qsTr("Use the profile color to theme the app")
                anchors.verticalCenter: parent.verticalCenter
            }
        }


        CheckBox {
            id: opaqueToolbar
            checked: Settings.opaqueToolbar()
            onCheckedChanged: {
                Settings.setValue("opaqueToolbar", checked)

                if (Settings.opaqueToolbar())
                    toolbar.opacity = 1
                else
                    toolbar.opacity = 0.9
            }

            Label {
                anchors.left: opaqueToolbar.right
                text: qsTr("Opaque toolbar")
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    ColorDialog {
        id: colorDialog
        title: qsTr("Chose profile color")
        color: Settings.value("userColor", colors.userColor)
        onAccepted: {
            Settings.setValue("userColor", color)
            colors.userColor = colorDialog.color
        }
    }

    Button {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 + parent.height / 16
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Done")
        enabled: textBox.length > 0 ? 1: 0
        onClicked: {
            Settings.setValue("userName", textBox.text)
            Settings.setValue("userColor", colorDialog.color)
            Settings.setValue("firstLaunch", false);
            Settings.setValue("customizedUiColor", customizedUiColor.checked)

            colors.userColor = colorDialog.color

            finishSetup(textBox.text)
            Qt.inputMethod.hide()
        }
    }
}
