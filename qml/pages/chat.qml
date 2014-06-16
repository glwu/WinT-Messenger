//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Dialogs 1.1
import "../controls" as Controls

Controls.Page {
    id: page
    flickable: false
    logoEnabled: false
    toolbarTitle: qsTr("Chat")

    property string iconPath
    property bool usersWidgetEnabled: false
    property bool emotesRectangleEnabled: false

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


    onWidthChanged: {
        if (!usersWidgetEnabled)
            usersPanel.anchors.leftMargin = width
    }

    onHeightChanged: {
        if (!emotesRectangleEnabled)
            emotesPanel.anchors.topMargin = height
    }

    Component.onCompleted: {
        toolbar.extraPages = false
        iconPath = settings.darkInterface() ? "qrc:/icons/ToolbarIcons/Light/" : "qrc:/icons/ToolbarIcons/Dark/"
        listModel.append({"from": "", "face": "/system/globe.png", "message": "Welcome to the chat room!", "localUser": false})
    }

    onVisibleChanged: {
        toolbar.extraPages = !visible

        if (!visible)
            bridge.stopChat()
        else
            listModel.append({"from": "", "face": "/system/globe.png", "message": "Welcome to the chat room!", "localUser": 0})
    }

    Connections {
        target: bridge
        onDrawMessage: {
            listModel.append({"from": from, "face": face, "message": message, "localUser": localUser})
            listView.positionViewAtEnd()
        }
    }

    ListView {
        id: listView
        model: listModel
        anchors {
            fill: parent
            margins: device.ratio(12)
            bottomMargin: sendRectangle.height + device.ratio(12)
        }

        delegate: Rectangle {
            opacity: 0
            color: "transparent"
            anchors.left: if (!localUser) return parent.left
            anchors.right: if (localUser) return parent.right
            height: background.height > device.ratio(80) ? background.height + device.ratio(16) : device.ratio(80)

            Component.onCompleted: opacity = 1
            Behavior on opacity{NumberAnimation{duration:250}}

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

            Controls.Label {
                visible: false
                text: message
                id: hiddenLabel
                font.pixelSize: device.ratio(15)
            }

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
                    if (text.paintedWidth > (page.width * 0.8 - 2 * image.width))
                        width = page.width * 0.95 - 2 * image.width + device.ratio(24)
                    else
                        width = text.paintedWidth + device.ratio(24)
                }

                Text {
                    id: text
                    smooth: true
                    color: colors.text
                    anchors.fill: parent
                    opacity: parent.opacity
                    font.family: global.font
                    textFormat: Text.RichText
                    onLinkActivated: openUrl(link)
                    wrapMode: TextEdit.WrapAnywhere
                    font.pixelSize: device.ratio(15)
                    renderType: Text.NativeRendering
                    anchors.margins: device.ratio(12)
                    width: parent.width - device.ratio(24)
                    height: parent.height - device.ratio(24)
                    text: message + dateAlign + "<font size=" + sizes.x_small + "px color=gray>"
                          + userName + Qt.formatDateTime(new Date(), "hh:mm:ss AP") + "</font></right></p>"

                    property string dateAlign: localUser ? "<p align=right>" : "<p align=left>"
                    property string userName: from != "" ? qsTr("By ") + from + " at " : ""
                }
            }
        }
    }

    Image {
        id: menuButton
        height: width
        asynchronous: true
        source: iconPath + "Grid.png"
        width: device.ratio(48)
        anchors {
            top: parent.top
            right: parent.right
            margins: device.ratio(12)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                usersWidgetEnabled = true
                usersPanel.anchors.leftMargin = 0
            }
        }
    }

    Controls.EmotesMenu {id: emotesPanel}

    Rectangle {
        id: sendRectangle
        color: "transparent"
        height: device.ratio(32)
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Controls.Button {
            id: attachButton
            width: parent.height
            onClicked: fileDialog.open()
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

        Controls.LineEdit {
            id: sendTextbox
            placeholderText: qsTr("Type a message...")
            anchors {rightMargin: device.ratio(-1); leftMargin: device.ratio(-1);}
            anchors {left: attachButton.right; right: emotesButton.left; bottom: parent.bottom; top: parent.top;}
            Keys.onReturnPressed: {
                if (text.length > 0) {
                    bridge.sendMessage(sendTextbox.text)
                    sendTextbox.text = ""
                }
            }
        }

        Controls.Button {
            id: emotesButton
            width: parent.height
            anchors {right: sendButton.left; bottom: parent.bottom; top: parent.top; rightMargin: device.ratio(-1);}

            Image {
                height: width
                enabled: parent.enabled
                width: device.ratio(16)
                anchors.centerIn: parent
                source: "qrc:/emotes/smiling.png"
            }

            onClicked: {
                if (emotesRectangleEnabled) {
                    emotesRectangleEnabled = false;
                    emotesPanel.anchors.topMargin = page.height;
                }

                else {
                    emotesRectangleEnabled = true;
                    emotesPanel.anchors.topMargin = page.height / 2;
                }
            }
        }

        Controls.Button {
            id: sendButton
            text: qsTr("Send")
            width: device.ratio(64)
            enabled: sendTextbox.length > 0 ? 1: 0
            anchors {right: parent.right; bottom: parent.bottom; top: parent.top;}
            onClicked: {
                bridge.sendMessage(sendTextbox.text)
                sendTextbox.text = ""
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: bridge.shareFile(fileUrl)
    }

    ListModel {id: listModel}
    Controls.UserMenu {id: usersPanel}
}
