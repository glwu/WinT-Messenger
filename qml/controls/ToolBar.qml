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

    property alias title: label.text
    property bool extraPages: true

    // A wrapper used in main.qml to load the settings
    function updateSettings() {
        settingsControl.updateValues()
    }

    // This image is used to go to the previous page in the stackview
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

    // This label is used to draw the toolbar title
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

    // This image is used to show the application menu
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
            onClicked: dialog.show()
        }
    }

    // This dialog allows us to open the about dialog, the settings dialog
    // and access other features.
    Dialog {
        id: dialog
        dWidth: column.width + device.ratio(16)
        dHeight: column.height + device.ratio(16)

        contents: Item {
            anchors.centerIn: parent

            Column {
                id: column
                enabled: dialog.enabled
                anchors.centerIn: parent
                spacing: device.ratio(-1)

                Button {
                    text: qsTr("About")
                    onClicked: {
                        dialog.hide()
                        aboutControl.show()
                    }
                }

                Button {
                    visible: extraPages
                    text: qsTr("Settings")
                    onClicked: {
                        dialog.hide()
                        settingsControl.show()
                    }
                }

                Button {
                    visible: !device.isMobile()
                    text: settings.fullscreen() ? qsTr("Normal window") :
                                                  qsTr("Fullscreen window")

                    onClicked: {
                        dialog.hide()
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
                    onClicked: dialog.hide()
                }

                Button {
                    id: quitButton
                    text: qsTr("Quit")
                    onClicked: Qt.quit()
                    visible: device.isMobile() ? false : settings.fullscreen()
                }
            }
        }
    }
}
