//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../Widgets"

Page {
    id: page
    property int  userCount: 0
    property bool showUsers: true

    logoEnabled  : false
    toolbarTitle : qsTr("LAN Chat")

    Connections {
        target: bridge
        onNewMessage:
            textbox.append(text)
    }

    Flickable {
        id: chatWidget
        contentHeight        : textbox.paintedHeight
        interactive          : true
        flickableDirection   : Flickable.VerticalFlick
        anchors.fill: parent
        anchors.topMargin: arrangeFirstItem
        anchors.margins: 12
        anchors.bottomMargin: 56

        function ensureVisible(r) {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit {
            id: textbox
            activeFocusOnPress       : false
            clip                     : true
            color                    : colors.text
            text                     : {
                "<font color = '#444'><samp>"
                        + qsTr("Welcome to the chat room!")
                        + "<br>"
                        + "-------------------------"
                        + "</samp></font><br>"
            }
            font.family              : defaultFont
            font.pixelSize           : smartFontSize(12)
            height                   : parent.height
            onCursorRectangleChanged : chatWidget.ensureVisible(cursorRectangle)
            readOnly                 : true
            textFormat               : TextEdit.RichText
            width                    : parent.width
            wrapMode                 : TextEdit.WrapAtWordBoundaryOrAnywhere
            onLinkActivated          : Qt.openUrlExternally(link)
        }
    }

    Rectangle {
        id: sendRectangle
        anchors.left: parent.left
        anchors.right: parent.right
        y: parent.height - height
        height: smartBorderSize(44)
        color: "white"

        BorderImage {
            border.bottom: 8
            source: controlPath + "Window.png"
            width: parent.width
            height: parent.height
        }

        Textbox {
            id: sendTextbox
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: emotesButton.left
            anchors.rightMargin: 6
            placeholderText: qsTr("Type a message...")

            Keys.onReturnPressed: {
                bridge.sendMessage(sendTextbox.text)
                sendTextbox.text = ""
            }
        }

        Button {
            id: emotesButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: sendButton.left
            anchors.rightMargin: 6
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/emotes/smile.png"
                width: smartBorderSize(16)
                height: smartBorderSize(16)
            }
        }

        Button {
            id: sendButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 6
            width: smartBorderSize(64)
            height: smartBorderSize(32)
            text: qsTr("Send")

            onClicked: {
                bridge.sendMessage(sendTextbox.text)
                sendTextbox.text = ""
            }
        }
    }
}
