//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Dialogs 1.1

Dialog {
    id: dialog

    // Set the size of the dialog
    dWidth: device.ratio(320)
    dHeight: device.ratio(420)

    // This are the actual conents of the dialog
    contents: Item {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.8

        Column {
            enabled: dialog.enabled
            spacing: device.ratio(4)
            anchors.centerIn: parent

            // This image is used to draw the application icon
            Image {
                width: height
                asynchronous: true
                height: device.ratio(128)
                source: "qrc:/icons/Logo.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize: Qt.size(device.ratio(128), device.ratio(128))
            }

            // This label is used to draw the application name & version
            Label {
                color: colors.logoTitle
                font.pixelSize: sizes.large
                text: "WinT Messenger v1.2.1"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // This label is used to draw the one-line description of the app.
            Label {
                color: colors.logoSubtitle
                font.pixelSize: device.ratio(14)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Simple and lightweight IM client")
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.horizontalCenter: parent.horizontalCenter
            }


            // This rectangle is used as a separator
            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(8)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // This label us used to give credit to the Tango project and the
            // Android icons as they are used in this application.
            Label {
                color: colors.logoSubtitle
                font.pixelSize: device.ratio(10)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("This project uses icons from the Tango " +
                           "project and Android")
            }

            // This rectangle is used as a separator
            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(16)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // This button is used to open the official website in the user's
            // web browser.
            Button {
                text: qsTr("Visit website")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: Qt.openUrlExternally("http://wint-im.sf.net")
            }

            // This button is used to check for updates (and if appliable) to
            // notify the user about a new update.
            Button {
                text: qsTr("Check for updates")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: bridge.checkForUpdates() ?
                               newUpdateMessage.open() : noUpdatesMessage.open()
            }

            // This button is used to hide the dialog.
            Button {
                text: qsTr("Close")
                onClicked: hide()
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // This message dialog is used to tell the user that a new update is
        // available.
        MessageDialog {
            id: newUpdateMessage
            icon: StandardIcon.Information
            title: qsTr("Update available")
            standardButtons: StandardButton.No | StandardButton.Yes

            text: qsTr("An update of WinT Messenger is available, " +
                       "do you want to open the official website " +
                       "to install it?")

            onButtonClicked: {
                if (clickedButton === StandardButton.Yes)
                    Qt.openUrlExternally("http://wint-im.sf.net")
            }
        }

        // This message dialog is used to tell the user that there are no
        // updates available.
        MessageDialog {
            id: noUpdatesMessage
            icon: StandardIcon.Information
            standardButtons: StandardButton.Ok
            title: qsTr("No updates available")
            text: qsTr("Congratulations, you are running the latest " +
                       "version of WinT Messenger!")
        }
    }
}
