//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import "../Widgets"

Page {
    id: preferences
    logoTitle: qsTr("Settings")
    toolbarTitle: qsTr("Settings")
    logoImageSource: "qrc:/images/Settings.png"
    logoSubtitle: qsTr("Customize WinT Messenger")

    onVisibleChanged: toolbar.controlButtonsEnabled = !visible
    Component.onCompleted: toolbar.controlButtonsEnabled = false

    Column {
        y: arrangeFirstItem
        spacing: DeviceManager.ratio(8)
        anchors {left: parent.left; right: parent.right; leftMargin: DeviceManager.ratio(24); rightMargin: DeviceManager.ratio(24);}

        Label {
            anchors.left: parent.left
            text: qsTr("Nickname and profile color:")
        }

        Rectangle {
            height: textBox.height
            color: colors.background
            anchors {left: parent.left; right: parent.right;}

            Textbox {
                id: textBox
                text: Settings.value("userName", "unknown")
                onTextChanged: Settings.setValue("userName", text)
                placeholderText: qsTr("Type a nickname and choose a profile color")
                anchors {left: parent.left; right: colorRectangle.left; rightMargin: 2;}
            }

            Rectangle {
                width: height
                id: colorRectangle
                height: textBox.height
                color: colors.userColor
                anchors.right: parent.right
                border.color: colors.borderColor
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
                    onClicked: colors.userColor = Settings.getDialogColor(colors.userColor);
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
}
