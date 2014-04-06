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
    id: preferences

    logoImageSource : "qrc:/images/Settings.png"
    logoSubtitle    : qsTr("Customize WinT Messenger")
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
        spacing: bridge.ratio(8)
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
                onTextChanged   : settings.setValue("userName", text)
            }

            Rectangle {
                id: colorRectangle
                anchors.right: parent.right

                height: textBox.height
                width : height
                border.width: 1

                color: colorDialog.color
                border.color: colors.borderColor

                onColorChanged: {
                    settings.setValue("userColor", colorDialog.color)
                    colors.userColor = colorDialog.color

                    if (settings.customizedUiColor())
                        colors.toolbarColor = colors.userColor
                    else
                        colors.toolbarColor = colors.toolbarColorStatic
                }

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
        }

        CheckBox {
            id: customizedUiColor
            checked: settings.customizedUiColor()
            onCheckedChanged: {
                settings.setValue("customizedUiColor", checked)

                if (settings.customizedUiColor())
                    colors.toolbarColor = colors.userColor
                else
                    colors.toolbarColor = colors.toolbarColorStatic
            }

            Label {
                anchors.left: customizedUiColor.right
                text: qsTr("Use the profile color to theme the app")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: sizes.control
            }
        }

        CheckBox {
            id: opaqueToolbar
            checked: settings.opaqueToolbar()
            onCheckedChanged: {
                settings.setValue("opaqueToolbar", checked)

                if (settings.opaqueToolbar())
                    toolbar.opacity = 1
                else
                    toolbar.opacity = 0.9
            }

            Label {
                anchors.left: opaqueToolbar.right
                text: qsTr("Opaque toolbar")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: sizes.control
            }
        }
    }
}
