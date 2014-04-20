//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
    property alias text: titleText.text
    property bool controlButtonsEnabled: true
    property bool fullscreen: Settings.fullscreen()

    opacity: 0.8
    height: DeviceManager.ratio(56)
    color: Qt.lighter(Qt.darker(colors.toolbarColor))
    anchors {left: parent.left; right: parent.right; top: parent.top;}

    Image {
        id: backButton
        asynchronous: true
        height: DeviceManager.ratio(48)
        opacity: stackView.depth > 1 ? 1: 0
        width: opacity > 0 ? DeviceManager.ratio(48) : 0
        source: "qrc:/images/ToolbarIcons/Common/Back.png"
        anchors {left: parent.left; leftMargin: DeviceManager.ratio(4); verticalCenter: parent.verticalCenter;}

        MouseArea {
            anchors.fill: parent
            id: backButtonMouseArea
            onClicked: popStackView()
        }

        Behavior on opacity {NumberAnimation{}}
    }

    Rectangle {
        color: "transparent"
        height: DeviceManager.ratio(48)
        anchors {right: parent.right; verticalCenter: parent.verticalCenter}
        width: closeButton.width + fullscreenButton.width + DeviceManager.ratio(12)

        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            id: controlButtonsMouseArea
        }

        Image {
            id: closeButton
            asynchronous: true
            height: DeviceManager.ratio(48)
            source: "qrc:/images/ToolbarIcons/Common/Close.png"
            anchors {right: parent.right; rightMargin: DeviceManager.ratio(4); verticalCenter: parent.verticalCenter;}

            width: {
                if (!DeviceManager.isMobile() && fullscreen)
                    if (controlButtonsMouseArea.containsMouse || !controlButtonsEnabled)
                        return height
                return 0
            }

            MouseArea {
                onClicked: close()
                anchors.fill: parent
            }

            Behavior on width {NumberAnimation{}}
        }

        Image {
            asynchronous: true
            id: fullscreenButton
            height: DeviceManager.ratio(48)
            anchors {right: closeButton.left; rightMargin: DeviceManager.ratio(4); verticalCenter: parent.verticalCenter;}

            width: {
                if (!DeviceManager.isMobile())
                    if (controlButtonsMouseArea.containsMouse || !controlButtonsEnabled)
                        return height
                return 0
            }

            source: fullscreen ? "qrc:/images/ToolbarIcons/Common/Normal.png" :
                                 "qrc:/images/ToolbarIcons/Common/Fullscreen.png"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    fullscreen = !fullscreen
                    Settings.setValue("fullscreen", !Settings.fullscreen())
                    fullscreen ? rootWindow.showFullScreen() : rootWindow.showNormal()
                }
            }

            Behavior on width {NumberAnimation{}}
        }

        Image {
            width: height
            opacity: enabled
            id: settingsButton
            asynchronous: true
            height: DeviceManager.ratio(48)
            enabled: controlButtonsEnabled
            source: "qrc:/images/ToolbarIcons/Common/Settings.png"
            anchors {right: parent.right; rightMargin: closeButton.width + fullscreenButton.width + DeviceManager.ratio(8); verticalCenter: parent.verticalCenter;}

            MouseArea {
                anchors.fill: parent
                onClicked: openPage("qrc:/QML/Pages/Preferences.qml")
            }

            Behavior on opacity {NumberAnimation{}}
        }

        Image {
            width: height
            id: aboutButton
            opacity: enabled
            asynchronous: true
            enabled: controlButtonsEnabled
            height: DeviceManager.ratio(48)
            source: "qrc:/images/ToolbarIcons/Common/About.png"
            anchors {right: settingsButton.left; rightMargin: DeviceManager.ratio(4); verticalCenter: parent.verticalCenter;}

            MouseArea {
                anchors.fill: parent
                onClicked: openPage("qrc:/QML/Pages/About.qml")
            }

            Behavior on opacity {NumberAnimation{}}
        }
    }

    Label {
        id: titleText
        opacity: 0.75
        color: colors.toolbarText
        font.pixelSize: sizes.toolbarTitle
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        x: backButton.x + backButton.width + backButton.y

        Behavior on x {NumberAnimation{easing.type: Easing.OutCubic}}
    }
}
