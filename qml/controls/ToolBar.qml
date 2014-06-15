//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Rectangle {
    opacity: 0.85
    height: device.ratio(56)
    color: colors.userColor
    anchors {left: parent.left; right: parent.right; top: parent.top;}

    /*Rectangle {
        color: Qt.lighter(parent.color, 1.2)
        height: 1
        width: parent.width
        anchors.bottomMargin: 1
        anchors.bottom: parent.bottom
    }

    Rectangle {
        height: 1
        width: parent.width
        anchors.bottom: parent.bottom
        color: Qt.darker(parent.color, 1.6)
    }*/

    property alias title: label.text
    property bool extraPages: true

    function setMenuEnabled(enabled) {
        menuButton.enabled = enabled
    }

    function updateSettings() {
        settingsControl.updateValues()
    }

    Image {
        id: backButton
        asynchronous: true
        height: device.ratio(48)
        width: opacity > 0 ? height : 0
        opacity: stackView.depth > 1 ? 1 : 0
        source: "qrc:/icons/ToolbarIcons/Common/Back.png"
        anchors {
            left: parent.left
            leftMargin: device.ratio(4)
            verticalCenter: parent.verticalCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: stackView.pop()
        }

        Behavior on opacity {NumberAnimation{}}
    }

    Label {
        id: label
        color: colors.toolbarText
        font.pixelSize: sizes.x_large
        x: backButton.width + device.ratio(12)
        anchors.verticalCenter: parent.verticalCenter

        Behavior on x {NumberAnimation{}}

        MouseArea {
            anchors.fill: parent
            onClicked: stackView.pop()
        }
    }

    Image {
        id: menuButton
        asynchronous: true
        width: device.ratio(48)
        height: device.ratio(48)
        opacity: enabled ? 1 : 0
        source: "qrc:/icons/ToolbarIcons/Common/Menu.png"
        anchors {
            right: parent.right
            rightMargin: device.ratio(4)
            verticalCenter: parent.verticalCenter
        }

        Behavior on opacity {NumberAnimation{}}

        MouseArea {
            anchors.fill: parent
            onClicked: menu.opacity = 1
        }
    }

    Rectangle {
        x: 0
        y: 0
        color: "#80000000"
        opacity: menu.opacity
        width: mainWindow.width
        height: mainWindow.height
        enabled: menu.opacity > 0 ? 1 : 0

        MouseArea {
            anchors.fill: parent
            onClicked: menu.opacity = 0
        }
    }

    Rectangle {
        id: menu
        opacity: 0
        color: colors.background
        border.color: colors.borderColor
        width: column.width + device.ratio(16)
        height: column.height + device.ratio(16)

        x: (stackView.width - width)   / 2
        y: (stackView.height - height) / 2

        Behavior on opacity {NumberAnimation{duration: 250}}

        Rectangle {
            color: "transparent"
            anchors.fill: parent
            border.width: device.ratio(2)
            border.color: Qt.lighter(parent.color, 1.2)
        }

        Rectangle {
            color: "transparent"
            anchors.fill: parent
            border.width: device.ratio(1)
            border.color: Qt.darker(parent.color, 1.6)
        }

        Column {
            id: column
            anchors.centerIn: parent
            spacing: device.ratio(-1)
            enabled: menu.opacity > 0 ? 1 : 0

            Button {
                text: qsTr("About")
                onClicked: {
                    menu.opacity = 0
                    aboutControl.show()
                }
            }

            Button {
                visible: extraPages
                text: qsTr("Settings")
                onClicked: {
                    menu.opacity = 0
                    settingsControl.show()
                }
            }

            Button {
                visible: !device.isMobile()
                text: settings.fullscreen() ? qsTr("Normal window") :
                                              qsTr("Fullscreen window")

                onClicked: {
                    menu.opacity = 0
                    settings.setValue("fullscreen", !settings.fullscreen())

                    if (settings.fullscreen()) {
                        quitButton.visible = true
                        mainWindow.showFullScreen()
                        text = qsTr("Normal window")
                    }

                    else {
                        mainWindow.showNormal()
                        quitButton.visible = false
                        text = qsTr("Fullscreen window")
                    }
                }
            }

            Button {
                text: qsTr("Cancel")
                onClicked: menu.opacity = 0
            }

            Button {
                id: quitButton
                text: qsTr("Quit")
                onClicked: Qt.quit()
                visible: device.isMobile() ? false : settings.fullscreen()
            }
        }
    }

    About {id: aboutControl}
    Settings {id: settingsControl}
}
