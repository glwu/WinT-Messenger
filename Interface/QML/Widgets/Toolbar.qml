//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
    property alias text: titleText.text
    property alias settingsButtonEnabled: settingsButton.enabled
    property alias aboutButtonEnabled: aboutButton.enabled

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    height: DeviceManager.ratio(56)
    opacity: Settings.opaqueToolbar() ? 1: 0.75
    color: colors.toolbarColorStatic

    Rectangle {
        anchors.fill: parent
        color: colors.toolbarColor
        opacity: 0.7
    }

    Image {
        id: backButton
        anchors.left: parent.left
        anchors.leftMargin: DeviceManager.ratio(4)
        anchors.verticalCenter: parent.verticalCenter

        width: opacity > 0 ? DeviceManager.ratio(48) : 0
        height: DeviceManager.ratio(48)

        asynchronous: true
        source: "qrc:/images/ToolbarIcons/Back.png"

        opacity: stackView.depth > 1 ? 1: 0

        MouseArea {
            id: backButtonMouseArea
            anchors.fill: parent
            onClicked: popStackView()
        }

        Behavior on opacity { NumberAnimation{} }
    }

    Image {
        id: settingsButton
        anchors.right: parent.right
        anchors.rightMargin: DeviceManager.ratio(4)
        anchors.verticalCenter: parent.verticalCenter

        height: DeviceManager.ratio(48)
        width: height

        opacity: enabled ? 1 : 0

        source: "qrc:/images/ToolbarIcons/Settings.png"
        asynchronous: true

        MouseArea {
            anchors.fill: parent
            onClicked: openPage("Pages/Preferences.qml")
        }

        Behavior on opacity { NumberAnimation{} }
    }

    Image {
        id: aboutButton
        anchors.right: settingsButton.left
        anchors.rightMargin: DeviceManager.ratio(4)
        anchors.verticalCenter: parent.verticalCenter

        height: DeviceManager.ratio(48)
        width: height

        opacity: enabled ? 1 : 0

        source: "qrc:/images/ToolbarIcons/About.png"
        asynchronous: true

        MouseArea {
            anchors.fill: parent
            onClicked: openPage("Pages/About.qml")
        }

        Behavior on opacity { NumberAnimation{} }
    }

    Label {
        id: titleText
        color: colors.toolbarText
        x: backButton.x + backButton.width + backButton.y
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: sizes.toolbarTitle
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        opacity: 0.75

        MouseArea {
            anchors.fill: parent
            onClicked: popStackView()
        }

        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
    }
}

