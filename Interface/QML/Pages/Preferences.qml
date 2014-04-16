//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import QtQuick.Controls 1.0
import "../Widgets"

Page {
    id: preferences

    logoImageSource: "qrc:/images/Settings.png"
    logoSubtitle: qsTr("Customize WinT Messenger")
    logoTitle: qsTr("Settings")
    toolbarTitle: qsTr("Settings")

    Component.onCompleted: {
        toolbar.aboutButtonEnabled = false
        toolbar.settingsButtonEnabled = false
   }

    onVisibleChanged: {
        toolbar.aboutButtonEnabled = !visible
        toolbar.settingsButtonEnabled = !visible
   }

    Column {
        spacing: DeviceManager.ratio(8)
        y: arrangeFirstItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 48
        anchors.rightMargin: 48

        Label {
            anchors.left: parent.left
            text: qsTr("Nickname and profile color:")
       }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: textBox.height
            color: colors.background

            Textbox {
                id: textBox
                anchors.left: parent.left
                anchors.right: colorRectangle.left
                anchors.rightMargin: 2
                placeholderText: qsTr("Type a nickname and choose a profile color")
                text: Settings.value("userName", "unknown")
                onTextChanged: Settings.setValue("userName", text)
           }

            Rectangle {
                id: colorRectangle
                anchors.right: parent.right
                height: textBox.height
                width: height
                border.width: 1
                color: colors.userColor
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
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: colors.userColor = Settings.getDialogColor(colors.userColor);
               }
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
                    toolbar.opacity = 0.75
           }

            Label {
                anchors.left: opaqueToolbar.right
                text: qsTr("Opaque toolbar")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: sizes.control
           }
       }

        CheckBox {
            id: darkInterface
            checked: Settings.darkInterface()
            onCheckedChanged: {Settings.setValue("darkInterface", checked); colors.setColors();}

            Label {
                anchors.left: darkInterface.right
                text: qsTr("Use a dark interface")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: sizes.control
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
                font.pixelSize: sizes.control
           }
       }
   }
}
