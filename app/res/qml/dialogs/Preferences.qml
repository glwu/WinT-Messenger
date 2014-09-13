//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"

import QtQuick 2.3
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2 as Controls

Dialog {
    id: dialog
    title: tr("Preferences")

    property bool showOnInit: settings.firstLaunch()

    onVisibleChanged: updateValues()
    Component.onCompleted: {
        updateValues()

        if (settings.firstLaunch())
            dialog.open()
    }

    onClosed: {
        if (settings.firstLaunch())
            dialog.open()
    }

    function updateValues() {
        customColor.selected = settings.customColor()
        darkInterface.selected = settings.darkInterface()
        notifyUpdates.selected = settings.notifyUpdates()
        soundsEnabled.selected = settings.soundsEnabled()

        colorDialog.color = theme.primary

        if (settings.firstLaunch()) {
            closeButton.text = tr("Done")
        }

        else {
            closeButton.text = tr("Close")
            textBox.text = settings.value("nickname", "unknown")
        }
    }

    contents: Column {
        id: column
        width: parent.width
        spacing: units.scale(8)
        anchors.centerIn: parent

        Label {
            fontSize: "medium"
            color: theme.logoTitle
            text: tr("User profile")
            anchors.left: parent.left
            anchors.margins: units.gu(1)
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(1)
            height: avatarImage.height * 1.2

            Rectangle {
                id: separator
                height: width
                width: units.gu(1.5)
                color: "transparent"
            }

            Image {
                height: width
                visible: true
                id: avatarImage
                asynchronous: true
                width: units.scale(48)
                anchors.left: separator.right
                anchors.verticalCenter: parent.verticalCenter

                Connections {
                    target: avatarMenu
                    onUpdateAvatarImage: avatarImage.source = "qrc:/faces/faces/" + image
                }

                Rectangle {
                    color: "transparent"
                    anchors.fill: parent
                    border.width: units.scale(1)
                    border.color: theme.borderColor

                    Rectangle {
                        id: _bg_hover
                        color: "black"
                        anchors.fill: parent
                        anchors.margins: parent.border.width
                        opacity: showOnInit   ||
                                 _mouseArea.containsMouse ||
                                 avatarMenu.showing ? 0.5 : 0

                        Behavior on opacity {NumberAnimation{}}
                    }

                    Label {
                        centered: true
                        color: "white"
                        text: tr("edit")
                        anchors.bottom: parent.bottom
                        opacity: _bg_hover.opacity > 0 ? 1 : 0
                        Behavior on opacity {NumberAnimation{}}
                        anchors.bottomMargin: parent.height / 8
                    }
                }

                source: "qrc:/faces/faces/" +
                        settings.value("face", "astronaut.jpg")

                MouseArea {
                    id: _mouseArea
                    anchors.fill: parent
                    hoverEnabled: !app.mobileDevice
                    onClicked: {
                        showOnInit = false
                        avatarMenu.toggle(_mouseArea)
                    }
                }
            }

            LineEdit {
                id: textBox
                anchors.margins: units.gu(1)
                anchors.left: avatarImage.right
                anchors.right: colorRectangle.left
                anchors.verticalCenter: avatarImage.verticalCenter
                onTextChanged: settings.setValue("nickname", text)
                placeholderText: tr("Type a nickname") + "..."
            }

            Rectangle {
                width: height
                id: colorRectangle
                height: textBox.height
                color: theme.primary
                anchors.right: parent.right
                border.width: units.scale(1)
                border.color: theme.borderColor
                anchors.verticalCenter: avatarImage.verticalCenter

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: colorDialog.open()
                }
            }
        }

        Rectangle {
            width: height
            color: "transparent"
            height: units.scale(4)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            fontSize: "medium"
            color: theme.logoTitle
            anchors.left: parent.left
            text: tr("Other settings")
            anchors.margins: units.gu(1)
        }

        Row {
            spacing: units.scale(8)
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(1)

            Rectangle {
                height: width
                width: units.gu(1)
                color: "transparent"
            }

            Column {
                spacing: units.scale(8)

                CheckBox {
                    width: height
                    id: soundsEnabled
                    text: tr("Enable sound effects")
                    onSelectedChanged: settings.setValue("soundsEnabled", selected)
                }

                CheckBox {
                    width: height
                    id: darkInterface
                    text: tr("Use a dark interface theme")
                    onSelectedChanged: {
                        settings.setValue("darkInterface", selected)
                        theme.setColors()
                    }
                }

                CheckBox {
                    width: height
                    id: customColor
                    text: tr("Use the profile color to theme the app")
                    onSelectedChanged: {
                        settings.setValue("customColor", selected)
                        theme.setColors()
                    }
                }

                CheckBox {
                    width: height
                    id: notifyUpdates
                    text: tr("Notify me when a new update is released")
                    onSelectedChanged: settings.setValue("notifyUpdates", selected)
                }
            }
        }

        Rectangle {
            width: height
            color: "transparent"
            height: units.scale(8)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            primary: true
            id: closeButton
            width: units.gu(22)
            radius: units.gu(0.5)
            anchors.horizontalCenter: parent.horizontalCenter

            enabled: {
                if (textBox.text.length < 3)
                    return false
                else
                    return true
            }

            onClicked: {
                if (settings.firstLaunch()) {
                    settings.setValue("firstLaunch", false)
                    notification.show(tr("To connect, click the \"Chat\" button"))
                }

                dialog.close()
            }
        }
    }

    ColorDialog {
        id: colorDialog
        title: tr("Chose profile color")
        onRejected: color = theme.primary
        onAccepted : {
            theme.primary = color
            settings.setValue("primary", theme.primary)
            theme.setColors()
        }
    }
}
