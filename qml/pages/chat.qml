//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.1
import "../controls" as Controls

Controls.Page {
    id: page

    // Configure the page to disable the central logo
    flickable: false
    logoEnabled: false
    toolbarTitle: qsTr("Chat")

    property string iconPath

    // Show a warning message on mobile devices if
    // the user tries to open a local file
    function openUrl(url) {
        console.log(url)
        Qt.openUrlExternally(url)
        if (device.isMobile()) {
            if (url.search("file:///") !== -1) {
                warningMessage.url = "Requested URL: " + url
                warningMessage.open()
            }
        }
    }

    // Disable the settings option, set the iconPath based on the theme
    // and welcome the user to the chat room.
    Component.onCompleted: {
        toolbar.extraPages = false
        iconPath = settings.darkInterface() ? "qrc:/icons/ToolbarIcons/Light/"
                                            : "qrc:/icons/ToolbarIcons/Dark/"
        listModel.append({
                             "from": "",
                             "face": "/system/globe.png",
                             "message": "Welcome to the chat room!",
                             "localUser": false
                         })
    }

    // Enable/disable the settings dialog when we enter or exit the chat room,
    // also, display a welcome message when we enter the chat room.
    onVisibleChanged: {
        toolbar.extraPages = !visible

        if (!visible)
            bridge.stopChat()
        else
            listModel.append({
                                 "from": "",
                                 "face": "/system/globe.png",
                                 "message": "Welcome to the chat room!",
                                 "localUser": 0})
    }

    // Append a new message when the Bridge notifies us about a new message
    Connections {
        target: bridge
        onDrawMessage: {
            listModel.append({
                                 "from": from,
                                 "face": face,
                                 "message": message,
                                 "localUser": localUser})

            listView.positionViewAtEnd()

            if (settings.soundsEnabled())
                bridge.playSound()
        }
    }

    // This list view shows all the messages (with a scrollbar)
    ScrollView {
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
                anchors.left: if (!localUser) return parent.left
                anchors.right: if (localUser) return parent.right
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
                    anchors.left: if (!localUser) return parent.left
                    anchors.right: if (localUser) return parent.right
                }

                // This is the background rectangle of each message
                Rectangle {
                    smooth: true
                    id: background
                    radius: device.ratio(2)
                    anchors.top: parent.top
                    opacity: parent.opacity
                    color: colors.buttonBackground
                    border.color: colors.borderColor
                    anchors.topMargin: device.ratio(12)
                    anchors.leftMargin: device.ratio(12)
                    anchors.rightMargin: device.ratio(12)
                    height: text.paintedHeight + device.ratio(24)
                    anchors.right: if (localUser) return image.left
                    anchors.left: if (!localUser) return image.right

                    Component.onCompleted: {
                        if (text.paintedWidth >
                                (page.width * 0.8 - 2 * image.width))
                            width = page.width * 0.95 - 2 * image.width +
                                    device.ratio(24)
                        else
                            width = text.paintedWidth + device.ratio(24)
                    }

                    // This is the text of each rectangle
                    Text {
                        id: text
                        smooth: true
                        color: colors.text
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
                              sizes.x_small +
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
    Controls.SlidingMenu {
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

            Rectangle {
                anchors.fill: parent
                color: toolbar.color
                Behavior on opacity {NumberAnimation{duration:100}}
                opacity: emotesMouseArea.containsMouse ? toolbar.opacity : 0
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
        color: "transparent"
        height: device.ratio(32)
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        // This button is used to share files
        Controls.Button {
            id: attachButton
            width: parent.height
            onClicked: bridge.shareFiles()
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            Image {
                height: width
                asynchronous: true
                width: device.ratio(32)
                anchors.centerIn: parent
                source: iconPath + "Attach.png"
            }
        }

        // This line edit is used to type our message
        Controls.LineEdit {
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
                if (text.length > 0) {
                    bridge.sendMessage(sendTextbox.text)
                    sendTextbox.text = ""
                }
            }
        }

        // This button is used to add emoticons to our message
        Controls.Button {
            id: emotesButton
            width: parent.height
            onClicked: emotesMenu.toggle()
            anchors {
                top: parent.top;
                bottom: parent.bottom;
                right: sendButton.left;
                rightMargin: device.ratio(-1);
            }

            Image {
                height: width
                enabled: parent.enabled
                width: device.ratio(16)
                anchors.centerIn: parent
                source: "qrc:/emotes/smiling.png"
            }
        }

        // This button is used to send the message written in sendTextbox
        Controls.Button {
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
}
