//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"

import QtQuick 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.0 as Controls

Dialog {
    id: dialog
    title: qsTr("Preferences")

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
        notifyUpdates.selected = settings.notifyUpdates()
        soundsEnabled.selected = settings.soundsEnabled()

        colorDialog.color = theme.primary

        if (settings.firstLaunch()) {
            closeButton.text = qsTr("Done")
        }

        else {
            closeButton.text = qsTr("Close")
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
            color: theme.secondary
            text: qsTr("User profile")
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

            CircularImage {
                height: width
                id: avatarImage
                width: units.scale(48)
                anchors.left: separator.right
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/faces/faces/" + settings.value("face", randomFace)

                ListView {
                    id: list
                    model: facesList
                }

                Connections {
                    target: avatarMenu
                    onUpdateAvatarImage: avatarImage.source = "qrc:/faces/faces/" + image
                }

                Frame {
                    radius: width / 2
                    color: "transparent"
                    anchors.fill: parent
                    anchors.margins: -units.scale(1)

                    Rectangle {
                        id: _bg_hover
                        color: "black"
                        radius: width / 2
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
                        text: qsTr("edit")
                        anchors.bottom: parent.bottom
                        opacity: _bg_hover.opacity > 0 ? 1 : 0
                        Behavior on opacity {NumberAnimation{}}
                        anchors.bottomMargin: parent.height / 8
                    }
                }

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
                placeholderText: qsTr("Type a nickname") + "..."
            }

            Frame {
                id: colorRectangle
                height: textBox.height
                color: theme.primary
                anchors.right: parent.right
                opacity: customColor.selected ? 1 : 0
                width: customColor.selected ?  height : 0
                anchors.verticalCenter: avatarImage.verticalCenter

                Behavior on width {NumberAnimation{}}
                Behavior on opacity {NumberAnimation{}}

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: colorDialog.open()
                    enabled: customColor.selected
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
            color: theme.secondary
            anchors.left: parent.left
            text: qsTr("Other settings")
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
                    text: qsTr("Enable sound effects")
                    onSelectedChanged: settings.setValue("soundsEnabled", selected)
                }

                CheckBox {
                    width: height
                    id: customColor
                    text: qsTr("Use the profile color to theme the app")
                    onSelectedChanged: {
                        settings.setValue("customColor", selected)
                        theme.setColors()
                    }
                }

                CheckBox {
                    width: height
                    id: notifyUpdates
                    text: qsTr("Notify me when a new update is released")
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
                    notification.show(qsTr("To connect, click the \"Chat\" button"))
                }

                dialog.close()
            }
        }
    }

    ColorDialog {
        id: colorDialog
        title: qsTr("Chose profile color")
        onRejected: color = theme.primary
        onAccepted : {
            theme.primary = color
            settings.setValue("primaryColor", theme.primary)
            theme.setColors()
        }
    }
}
