//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Dialogs 1.1

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

    function show() {
        menu.opacity = 1
    }

    Rectangle {
        id: menu
        opacity: 0
        anchors.centerIn: parent
        color: colors.background
        height: device.ratio(384)
        width: device.ratio(300)
        border.color: colors.borderColor

        MouseArea {anchors.fill: parent}
        Behavior on opacity {NumberAnimation{duration: 250}}

        Column {
            anchors.centerIn: parent
            spacing: device.ratio(4)
            width: parent.width * 0.8
            height: parent.height * 0.8
            enabled: menu.opacity > 0 ? 1 : 0

            Image {
                width: height
                asynchronous: true
                height: device.ratio(128)
                source: "qrc:/icons/Logo.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize: Qt.size(device.ratio(128), device.ratio(128))
            }

            Label {
                color: colors.logoTitle
                font.pixelSize: sizes.large
                text: "WinT Messenger v1.2.0"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                color: colors.logoSubtitle
                font.pixelSize: device.ratio(14)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Simple and lightweight IM client")
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(8)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                color: colors.logoSubtitle
                font.pixelSize: device.ratio(10)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("This project uses icons from the Tango project and Android")
            }

            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(16)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                text: qsTr("Visit website")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: Qt.openUrlExternally("http://wint-im.sf.net")
            }

            Button {
                text: qsTr("Check for updates")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: updater.checkForUpdates() ? newUpdateMessage.open() : noUpdatesMessage.open()
            }

            Button {
                text: qsTr("Close")
                onClicked: menu.opacity = 0
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    MessageDialog {
        id: newUpdateMessage
        icon: StandardIcon.Information
        title: qsTr("Update available")
        standardButtons: StandardButton.No | StandardButton.Yes
        text: qsTr("An update of WinT Messenger is available, do you want to open the official website to install it?")
        onButtonClicked: {
            if (clickedButton === StandardButton.Yes)
                Qt.openUrlExternally("http://wint-im.sf.net")
        }
    }

    MessageDialog {
        id: noUpdatesMessage
        icon: StandardIcon.Information
        standardButtons: StandardButton.Ok
        title: qsTr("No updates available")
        text: qsTr("Congratulations, you are running the latest version of WinT Messenger!")
    }
}

