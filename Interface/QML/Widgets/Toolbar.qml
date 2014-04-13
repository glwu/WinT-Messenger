//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Rectangle {
    property int buttonSize: DeviceManager.ratio(48)
    property alias text: titleText.text
    property alias backButtonOpacity: backButton.opacity
    property alias backButtonArea: backMouseArea
    property bool backButtonEnabled
    property bool settingsButtonEnabled: true
    property bool aboutButtonEnabled: true

    height: DeviceManager.ratio(56)
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    color: colors.toolbarColorStatic
    opacity: Settings.opaqueToolbar() ? 1: 0.75

    Rectangle {
        color: colors.toolbarColor
        anchors.fill: parent
        opacity: 0.97
    }

    Item {
        id: backButton
        anchors.left: parent.left
        anchors.leftMargin: DeviceManager.ratio(4)
        anchors.verticalCenter: parent.verticalCenter
        height: buttonSize
        width: opacity > 0 ? backImage.width: 0
        enabled: parent.backButtonEnabled

        Image {
            id: backImage
            source: "qrc:/images/ToolbarIcons/Back.png"
            height: buttonSize
            width: height
            asynchronous: true
            smooth: true
            //sourceSize: Qt.size(height, height)
        }

        MouseArea {
            id: backMouseArea
            anchors.fill: parent
        }

        Behavior on opacity { NumberAnimation{} }
    }

    Item {
        id: settingsButton
        anchors.right: parent.right
        anchors.rightMargin: DeviceManager.ratio(4)
        anchors.verticalCenter: parent.verticalCenter
        height: buttonSize
        width: height
        enabled: settingsButtonEnabled
        opacity: settingsButtonEnabled ? 1: 0

        Behavior on opacity { NumberAnimation{} }

        Image {
            id: settingsImage
            anchors.fill: parent
            source: "qrc:/images/ToolbarIcons/Settings.png"
            height: buttonSize
            width: height
            //sourceSize: Qt.size(height, height)
            smooth: true
            asynchronous: true
        }

        MouseArea {
            id: settingsMouseArea
            anchors.fill: parent
            onClicked: {
                openPage("Pages/Preferences.qml")
                enableSettingsButton(false)
            }
        }
    }

    Item {
        id: aboutButton
        anchors.right: settingsButton.left
        anchors.rightMargin: DeviceManager.ratio(4)
        anchors.verticalCenter: parent.verticalCenter
        height: buttonSize
        width: height
        enabled: aboutButtonEnabled
        opacity: aboutButtonEnabled ? 1: 0

        Behavior on opacity { NumberAnimation{} }
        Behavior on anchors.rightMargin { NumberAnimation{}}

        Image {
            id: aboutImage
            anchors.fill: parent
            source: "qrc:/images/ToolbarIcons/About.png"
            height: buttonSize
            width: height
            //sourceSize: Qt.size(height, height)
            smooth: true
            asynchronous: true
        }

        MouseArea {
            id: aboutMouseArea
            anchors.fill: parent
            onClicked: {
                openPage("Pages/About.qml")
                enableAboutButton(false)
            }
        }
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
            onClicked: stackView.pop()
        }

        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
    }
}

