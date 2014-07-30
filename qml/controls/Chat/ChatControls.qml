//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../Core"
import "../Dialogs"

import QtQuick 2.2
import QtQuick.Controls 1.1 as Controls

Item {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    height: device.ratio(32)

    // Create the open file dialog
    OpenFileDialog {
        id: dialog
    }

    property Popover emotesMenu: Popover {
        id: emotesMenu
        overlayColor: "transparent"

        height: width * 0.8
        width: app.width < app.height ? app.width * 0.9 : device.ratio(256)

        Behavior on width {NumberAnimation{}}
        Behavior on height {NumberAnimation{}}

        // Create a scroll view with the emotes
        Controls.ScrollView {
            anchors.fill: parent
            anchors.margins: device.ratio(12)

            // Show the emotes in a GridView
            GridView {
                id: emoteView
                model: emotesList
                cellWidth: device.ratio(36)
                cellHeight: device.ratio(36)

                // Configure each emote delegate
                delegate: Rectangle {
                    width: height
                    color: "transparent"
                    height: device.ratio(32)

                    Rectangle {
                        color: "#49759C"
                        anchors.fill: parent
                        opacity: emotesMouseArea.containsMouse ?  1 : 0
                    }

                    Image {
                        height: width
                        asynchronous: true
                        width: device.ratio(25)
                        anchors.centerIn: parent
                        source: "qrc:/emotes/" + modelData
                    }

                    MouseArea {
                        id: emotesMouseArea
                        anchors.fill: parent
                        hoverEnabled: !device.isMobile()
                        onClicked: {
                            sendTextbox.text = sendTextbox.text + " [s]" + modelData + "[/s] "
                        }
                    }
                }
            }
        }
    }

    // Create the chat controls
    Rectangle {
        height: device.ratio(32)
        border.width: device.ratio(1)
        color: theme.buttonBackground
        border.color: theme.borderColor

        // Set the anchors
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom

            rightMargin: device.ratio(-1)
            bottomMargin: device.ratio(-1)
        }

        // Close the emotes when another thing is clicked
        MouseArea {
            anchors.fill: parent
            onClicked: emotesMenu.close()
        }

        // Generate the attach button
        Button {
            iconName: "clip"
            id: attachButton
            width: parent.height
            onClicked: !device.isMobile() ? dialog.open() : bridge.shareFiles()

            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
        }

        // Generate the message text field
        TextField {
            id: sendTextbox
            placeholderText: qsTr("Type a message...")

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: attachButton.right
                right: emotesButton.left

                rightMargin: device.ratio(-1)
                leftMargin: device.ratio(-1)
            }

            Keys.onReturnPressed: {
                if (length > 0) {
                    bridge.sendMessage(text)
                    text = ""
                }
            }
        }

        // Generate the emotes menu button
        Button {
            iconName: "smile-o"
            id: emotesButton
            toggleButton: true
            width: parent.height
            onClicked: emotesMenu.toggle(caller)

            anchors {

                top: parent.top;
                bottom: parent.bottom;
                right: sendButton.left;
                rightMargin: device.ratio(-1);
            }
        }

        // Generate the send button
        Button {
            id: sendButton
            iconName: "send"
            enabled: sendTextbox.length > 0 ? 1: 0
            text: device.isMobile() ? "" : qsTr("Send")
            width: device.isMobile() ? height : device.ratio(86)

            anchors {
                right: parent.right
                bottom: parent.bottom
                top: parent.top
            }

            onClicked: {
                emotesMenu.close()
                bridge.sendMessage(sendTextbox.text)
                sendTextbox.text = ""
            }
        }
    }
}
