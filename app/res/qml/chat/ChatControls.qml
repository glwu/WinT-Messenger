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
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.2 as Controls

Item {
    height: units.gu(4)


    // This signal is emitted when the user
    // clicks on the "Share File" button
    signal shareFileClicked

    // This signal is emitted when the user
    // clicks on the "Send" button or presses
    // ENTER in the message line edit
    signal newMessage(var message)

    // Clear the textbox when a message is sent
    onNewMessage: _message_textbox.text = ""

    // Draw the message controls on the bottom of the window
    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }

    // Add a shadow under the message controls to give them some
    // depth.
    RectangularGlow {
        opacity: 0.5
        anchors.fill: _bg
        glowRadius: units.scale(6)
        color: settings.darkInterface() ? theme.shadow : "#aeaeae"
    }

    // Create the background item
    Item {
        id: _bg
        anchors.fill: parent

        // Create the button to share files
        Button {
            id: _share_file
            iconName: "clip"
            onClicked: shareFileClicked()

            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
        }

        // Create the message textbox
        LineEdit {
            blueFocus: false
            id: _message_textbox
            placeholderText: tr("Type a message...")
            Keys.onReturnPressed: newMessage(_message_textbox.text)

            anchors {
                top: parent.top
                right: _smileys.left
                bottom: parent.bottom
                left: _share_file.right
                leftMargin: -units.scale(1)
                rightMargin: -units.scale(1)
            }
        }

        // Create the smileys button
        Button {
            id: _smileys
            iconName: "smile-o"
            toggled: smileys.showing
            onClicked: smileys.toggle(_smileys)

            anchors {
                top: parent.top
                right: _send.left
                bottom: parent.bottom
                rightMargin: -units.scale(1)
            }
        }

        // Create the send button
        Button {
            id: _send
            iconName: "send"
            text: app.mobileDevice ? "" : tr("Send")
            onClicked: newMessage(_message_textbox.text)

            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
        }
    }

    // Create the smileys menu
    Menu {
        id: smileys
        width: app.width < app.height ? app.width * 0.9 : units.gu(32)

        Behavior on width {NumberAnimation{}}
        Behavior on height {NumberAnimation{}}

        // Display the smileys inside a scroll view
        Controls.ScrollView {
            anchors.centerIn: parent

            // Arrange all detected smileys in a grid
            GridView {
                model: emojiList
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.margins: units.gu(1)

                cellWidth: units.gu(4.5)
                cellHeight: units.gu(4.5)

                delegate: Image {
                    smooth: true
                    width: units.gu(2.25)
                    height: units.gu(2.25)
                    sourceSize: Qt.size(width, height)
                    source: "qrc:/smileys/smileys/" + modelData

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            smileys.close()
                            _message_textbox.forceActiveFocus()
                            _message_textbox.text = _message_textbox.text + bridge.manageSmileys(modelData)
                        }
                    }
                }
            }
        }
    }
}
