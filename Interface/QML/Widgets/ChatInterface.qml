//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Item {
    id: page
    anchors.fill: parent

    function setText(text, color) {textbox.text = "<font color=" + color + ">" + text + "</font><br>"}

    // Private global properties
    property string iconPath
    property bool usersWidgetEnabled: false
    property bool emotesRectangleEnabled: false

    onWidthChanged: {
        if (!usersWidgetEnabled)
            usersPanel.anchors.leftMargin = width
    }

    onHeightChanged: {
        if (!emotesRectangleEnabled)
            emotesPanel.anchors.topMargin = height
    }

    Component.onCompleted: {
        usersPanel.addUser(("You") + " (" + Settings.value("userName", "unknown") + ")")
        iconPath = Settings.darkInterface() ? "qrc:/images/ToolbarIcons/Light/" : "qrc:/images/ToolbarIcons/Dark/"
    }

    Connections {
        target: Bridge
        onNewMessage: {
            textbox.append(text)
            if (textbox.lineCount > textbox.cursorPosition)
                textbox.cursorPosition = textbox.lineCount
        }
    }

    Flickable {
        clip: true
        id: chatWidget
        interactive: true
        contentHeight: textbox.paintedHeight
        flickableDirection: Flickable.VerticalFlick
        anchors {fill: parent; bottomMargin: sendRectangle.height + 12; margins: 12;}

        TextEdit {
            clip: true
            id: textbox
            readOnly: true
            width: page.width
            color: colors.text
            anchors.fill: parent
            wrapMode: TextEdit.WordWrap
            textFormat: TextEdit.RichText
            renderType: Text.NativeRendering
            onLinkActivated: Bridge.openLink(link)
            font {family: defaultFont; pixelSize: DeviceManager.ratio(14)}
        }
    }

    Image {
        id: menuButton
        height: width
        asynchronous: true
        source: iconPath + "Grid.png"
        width: DeviceManager.ratio(48)
        anchors {top: parent.top; right: parent.right; margins: 12;}

        MouseArea {
            anchors.fill: parent
            onClicked: {
                usersWidgetEnabled = true
                usersPanel.anchors.leftMargin = 0
            }
        }
    }

    Rectangle {
        id: sendRectangle
        color: "transparent"
        height: DeviceManager.ratio(32)
        anchors {left: parent.left; right: parent.right; bottom: parent.bottom}

        Button {
            id: attachButton
            width: parent.height
            onClicked: Bridge.attachFile()
            anchors {left: parent.left; top: parent.top; bottom: parent.bottom}

            Image {
                height: width
                asynchronous: true
                width: DeviceManager.ratio(32)
                source: iconPath + "Attach.png"
                anchors {horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter;}
            }
        }

        Button {
            id: btButton
            visible: enabled
            enabled: Bridge.btChatEnabled()
            onClicked: Bridge.showBtSelector()
            width: visible ? parent.height : 0
            anchors {bottom: parent.bottom; left: attachButton.right; top: parent.top; leftMargin: -1;}

            Image {
                height: width
                asynchronous: true
                source: iconPath + "Bluetooth.png"
                width: parent.visible ? DeviceManager.ratio(32) : 0
                anchors {horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter;}
            }
        }

        Textbox {
            id: sendTextbox
            placeholderText: qsTr("Type a message...")
            anchors {rightMargin: -1; leftMargin: -1;}
            anchors {left: btButton.right; right: emotesButton.left; bottom: parent.bottom; top: parent.top;}
            Keys.onReturnPressed: {
                if (text.length > 0) {
                    Bridge.sendMessage(sendTextbox.text)
                    sendTextbox.text = ""
                }
            }
        }

        Button {
            id: emotesButton
            width: parent.height
            anchors {right: sendButton.left; bottom: parent.bottom; top: parent.top; rightMargin: -1;}

            Image {
                height: width
                enabled: parent.enabled
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/smile.png"
                anchors {horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter;}
            }

            onClicked: {
                enabled = false
                emotesRectangleEnabled = true
                emotesPanel.anchors.topMargin = page.height / 2
            }
        }

        Button {
            id: sendButton
            text: qsTr("Send")
            width: DeviceManager.ratio(64)
            enabled: sendTextbox.length > 0 ? 1: 0
            anchors {right: parent.right; bottom: parent.bottom; top: parent.top;}
            onClicked: {
                Bridge.sendMessage(sendTextbox.text)
                sendTextbox.text = ""
            }
        }
    }

    Emotes {id: emotesPanel}
    Users {id: usersPanel}
}
