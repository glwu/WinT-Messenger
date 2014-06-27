//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0
import QtQuick.Controls 1.0 as Controls

Page {
    id: chat
    title: qsTr("Chat")
    anchors.fill: parent
    property string iconPath

    rightWidgets: [
        Button {
            flat: true
            iconName: "user"
            onClicked: userSidebar.toggle()
            onVisibleChanged: visible ? opacity = 1 : opacity = 0
            textColor: userSidebar.expanded ? theme.info : theme.textColor

            Behavior on opacity {NumberAnimation{}}
        },

        Button {
            flat: true
            iconName: "bars"
            onClicked: menu.toggle(caller)
            textColor: menu.visible ? theme.info : theme.textColor
        }
    ]

    // Refresh the chat interface when we enter and exit the room
    onVisibleChanged: {

        // Stop the chat interface and clear the messages
        if (!visible) {
            preferencesMenuEnabled = true
            bridge.stopChat()
            listModel.clear()
        }

        // Start the chat inteface and welcome the user
        else {
            preferencesMenuEnabled = false
            bridge.startChat()
            listModel.append(
                        {
                            "from": "",
                            "face": "/system/globe.png",
                            "message": "Welcome to the chat room!",
                            "localUser": false
                        })
        }
    }

    // Here is the item with all the chat dialogs and controls
    // Here be dragons
    Item {
        anchors.top: parent.top
        anchors.right: userSidebar.left
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.rightMargin: device.ratio(-1)

        // Append a new message when the Bridge notifies us about a new message
        Connections {
            target: bridge
            onDrawMessage: {
                listModel.append(
                            {
                                "from": from,
                                "face": face,
                                "message": message,
                                "localUser": localUser
                            })

                listView.positionViewAtEnd()

                if (settings.soundsEnabled())
                    bridge.playSound()
            }
        }

        // This list view shows all the messages (with a scrollbar)
        Controls.ScrollView {
            anchors {
                fill: parent
                bottomMargin: sendRectangle.height
            }

            ListView {
                id: listView
                anchors.fill: parent

                // The list model with the message data
                model: ListModel {
                    id: listModel
                }

                // This is the message itself
                delegate: Rectangle {
                    opacity: 0
                    color: "transparent"
                    anchors.left:  if (localUser != 1) return parent.left
                    anchors.right: if (localUser == 1) return parent.right

                    height: background.height > device.ratio(80) ?
                                background.height + device.ratio(16) :
                                device.ratio(80)

                    Component.onCompleted: opacity = 1
                    Behavior on opacity{NumberAnimation{duration:250}}

                    // This is the profile picture of each message
                    Image {
                        id: image
                        height: width
                        asynchronous: true
                        width: device.ratio(64)
                        opacity: parent.opacity
                        anchors.top: parent.top
                        source: "qrc:/faces/" + face
                        anchors.margins: device.ratio(12)
                        anchors.left:  if (localUser != 1) return parent.left
                        anchors.right: if (localUser == 1) return parent.right

                        // Draw a border around the image only if its not transparent
                        Rectangle {
                            color: "transparent"
                            anchors.fill: parent
                            border.width: device.ratio(1)
                            border.color: {
                                if (image.source.toString().search(".png") == -1)
                                    return theme.borderColor
                                else
                                    return "transparent"
                            }
                        }
                    }

                    // This is the background rectangle of each message
                    Rectangle {
                        smooth: true
                        id: background
                        color: theme.panel
                        radius: device.ratio(2)
                        anchors.top: parent.top
                        opacity: parent.opacity
                        border.color: theme.borderColor
                        anchors.topMargin: device.ratio(12)
                        anchors.leftMargin: device.ratio(12)
                        anchors.rightMargin: device.ratio(12)
                        height: text.paintedHeight + device.ratio(24)
                        anchors.right: if (localUser == 1) return image.left
                        anchors.left:  if (localUser != 1) return image.right

                        // Resize the rectangle according to the length of the message
                        Component.onCompleted: {
                            if (text.paintedWidth >
                                    (chat.width * 0.8 - 2 * image.width))
                                width = chat.width * 0.95 - 2 * image.width +
                                        device.ratio(24)
                            else
                                width = text.paintedWidth + device.ratio(24)
                        }

                        // This is the text of each rectangle
                        Text {
                            id: text
                            smooth: true
                            color: theme.textColor
                            anchors.fill: parent
                            opacity: parent.opacity
                            font.family: global.font
                            textFormat: Text.RichText
                            onLinkActivated: openUrl(link)
                            font.pixelSize: device.ratio(14)
                            renderType: Text.NativeRendering
                            anchors.margins: device.ratio(12)
                            width: parent.width - device.ratio(24)
                            height: parent.height - device.ratio(24)
                            wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                            text: message +
                                  dateAlign +
                                  "<font size=" +
                                  units.gu(1.2) +
                                  "px color=gray>" +
                                  userName +
                                  Qt.formatDateTime(new Date(), "hh:mm:ss AP") +
                                  "</font></right></p>"

                            property string dateAlign: localUser ?
                                                           "<p align=right>" : "<p align=left>"

                            property string userName: from != "" ?
                                                          qsTr("By ") + from + " at " : ""
                        }
                    }
                }
            }
        }

        // This is the emoticon menu
        SlidingMenu {
            id: emotesMenu
            title: qsTr("Emotes")
            cellWidth: device.ratio(42)
            cellHeight: device.ratio(42)
            anchors.bottomMargin: sendRectangle.height

            // This is the emoticon button control
            delegate: Rectangle {
                width: height
                height: device.ratio(30)
                color: "transparent"

                // Show a rectangle while a emote is hovered
                Rectangle {
                    color: theme.panel
                    anchors.fill: parent
                    opacity: emotesMouseArea.containsMouse ?  1 : 0
                }

                // The image of each emoticon
                Image {
                    height: width
                    asynchronous: true
                    width: device.ratio(15)
                    anchors.centerIn: parent
                    source: "qrc:/emotes/" + name + ".png"
                }

                // This mouse area inserts the selected emoticon in the textbox
                MouseArea {
                    id: emotesMouseArea
                    anchors.fill: parent
                    hoverEnabled: !device.isMobile()
                    onClicked: {
                        emotesMenu.toggle()
                        sendTextbox.text = sendTextbox.text +
                                " [s]" +
                                name +
                                "[/s] "
                    }
                }
            }

            // A list model with all registered emoticons
            model: ListModel {
                ListElement {name: "angel"}
                ListElement {name: "angry"}
                ListElement {name: "aww"}
                ListElement {name: "blushing"}
                ListElement {name: "confused"}
                ListElement {name: "cool"}
                ListElement {name: "creepy"}
                ListElement {name: "crying"}
                ListElement {name: "cthulhu"}
                ListElement {name: "cute_winking"}
                ListElement {name: "cute"}
                ListElement {name: "devil"}
                ListElement {name: "frowning"}
                ListElement {name: "gasping"}
                ListElement {name: "greedy"}
                ListElement {name: "grinning"}
                ListElement {name: "happy_smiling"}
                ListElement {name: "happy"}
                ListElement {name: "heart"}
                ListElement {name: "irritated_2"}
                ListElement {name: "irritated"}
                ListElement {name: "kissing"}
                ListElement {name: "laughing"}
                ListElement {name: "lips_sealed"}
                ListElement {name: "madness"}
                ListElement {name: "malicious"}
                ListElement {name: "naww"}
                ListElement {name: "pouting"}
                ListElement {name: "shy"}
                ListElement {name: "sick"}
                ListElement {name: "smiling"}
                ListElement {name: "speechless"}
                ListElement {name: "spiteful"}
                ListElement {name: "stupid"}
                ListElement {name: "surprised_2"}
                ListElement {name: "surprised"}
                ListElement {name: "terrified"}
                ListElement {name: "thumbs_down"}
                ListElement {name: "thumbs_up"}
                ListElement {name: "tired"}
                ListElement {name: "tongue_out_laughing"}
                ListElement {name: "tongue_out_left"}
                ListElement {name: "tongue_out_up_left"}
                ListElement {name: "tongue_out_up"}
                ListElement {name: "tongue_out"}
                ListElement {name: "unsure_2"}
                ListElement {name: "unsure"}
                ListElement {name: "winking_grinning"}
                ListElement {name: "winking_tongue_out"}
                ListElement {name: "winking"}
            }
        }

        // This rectangle stores the messaging controls, such as the
        // send button and the message textbox
        Rectangle {
            id: sendRectangle
            color: theme.buttonBackground
            border.width: device.ratio(1)
            border.color: theme.borderColor
            height: device.ratio(32)
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            // This button is used to share files
            Button {
                id: attachButton
                width: parent.height
                iconName: "file"
                onClicked: device.isMobile() ? dialog.open() : bridge.shareFiles()

                anchors {
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom
                }
            }

            // This line edit is used to type our message
            TextField {
                id: sendTextbox
                placeholderText: qsTr("Type a message...")

                anchors {
                    left: attachButton.right
                    right: emotesButton.left
                    bottom: parent.bottom
                    top: parent.top
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

            // This button is used to add emoticons to our message
            Button {
                id: emotesButton
                width: parent.height
                iconName: "smile-o"
                onClicked: emotesMenu.toggle()
                anchors {
                    top: parent.top;
                    bottom: parent.bottom;
                    right: sendButton.left;
                    rightMargin: device.ratio(-1);
                }
            }

            // This button is used to send the message written in sendTextbox
            Button {
                id: sendButton
                text: qsTr("Send")
                width: device.ratio(64)
                enabled: sendTextbox.length > 0 ? 1: 0

                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    top: parent.top
                }

                onClicked: {
                    bridge.sendMessage(sendTextbox.text)
                    sendTextbox.text = ""
                }
            }
        }

        // This dialog is used to share a file to the peers
        OpenFileDialog {
            id: dialog
        }
    }

    // This is the side bar with a list of users
    Sidebar {
        mode: "right"
        id: userSidebar
        expanded: false
        header: qsTr("Connected users")

        function toggle() {
            expanded = !expanded
        }
    }
}
