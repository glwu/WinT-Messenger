//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import "../Widgets"

Page {
    logoTitle: qsTr("Initial setup")
    toolbarTitle: qsTr("Initial setup")
    logoImageSource: "qrc:/images/Logo.png"
    logoSubtitle: qsTr("Customize your setup")

    Component.onCompleted: toolbar.controlButtonsEnabled = false

    function finishSetup() {
        if (textBox.length > 0) {
            Settings.setValue("userName", textBox.text)
            Settings.setValue("userColor", colors.userColor)
            Settings.setValue("firstLaunch", false)
            Settings.setValue("customizedUiColor", customizedUiColor.checked)
            Settings.setValue("darkInterface", darkInterface.checked)

            toolbar.controlButtonsEnabled = true
            stackView.clear()
            stackView.push("qrc:/QML/Pages/Start.qml")

            Qt.inputMethod.hide()
        }
    }

    Column {
        y: arrangeFirstItem
        spacing: DeviceManager.ratio(8)
        anchors {left: parent.left; right: parent.right; leftMargin: DeviceManager.ratio(24); rightMargin: DeviceManager.ratio(24);}

        Rectangle {
            color: "transparent"
            height: textBox.height
            anchors {left: parent.left; right: parent.right;}

            Textbox {
                id: textBox
                Keys.onReturnPressed: finishSetup()
                placeholderText: qsTr("Type a nickname and choose a profile color")
                anchors {left: parent.left; right: colorRectangle.left; rightMargin: DeviceManager.ratio(2)}
            }

            Rectangle {
                id: colorRectangle
                width: height
                border.width: 1
                height: textBox.height
                color: colors.userColor
                anchors.right: parent.right
                border.color: {
                    if (mouseArea.containsMouse)
                        return colors.borderColor
                    else if (mouseArea.pressed)
                        return colors.borderColor
                    else
                        return colors.borderColor
                }

                onColorChanged: {
                    Settings.setValue("userColor", colors.userColor)

                    if (Settings.customizedUiColor())
                        colors.toolbarColor = colors.userColor
                    else
                        colors.toolbarColor = colors.toolbarColorStatic
                }

                MouseArea {
                    id: mouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: colors.userColor = Settings.getDialogColor(colors.userColor)
                }
            }
        }

        Checkbox {
            width: height
            id: darkInterface
            checked: Settings.darkInterface()
            labelText: qsTr("Use a dark interface theme")
            onCheckedChanged: {Settings.setValue("darkInterface", checked); colors.setColors();}
        }

        Checkbox {
            id: customizedUiColor
            checked: Settings.customizedUiColor()
            labelText: qsTr("Use the profile color to theme the app")
            onCheckedChanged: {
                Settings.setValue("customizedUiColor", checked)

                if (Settings.customizedUiColor())
                    colors.toolbarColor = colors.userColor
                else
                    colors.toolbarColor = colors.toolbarColorStatic
            }
        }
    }

    Button {
        text: qsTr("Done")
        onClicked: finishSetup()
        enabled: textBox.length > 0 ? 1: 0
        anchors {bottom: parent.bottom; bottomMargin: 10 + parent.height / 16; horizontalCenter: parent.horizontalCenter;}
    }
}
