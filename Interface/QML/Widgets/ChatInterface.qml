//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2

Item {
    id: page
    anchors.fill: parent

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
        anchors.fill         : parent
        anchors.topMargin    : arrangeFirstItem
        anchors.margins      : 12
        anchors.bottomMargin : sendRectangle.height + 12

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
            anchors.fill             : parent
            clip                     : true
            color                    : colors.text
            font.family              : defaultFont
            font.pixelSize           : smartFontSize(16)
            onCursorRectangleChanged : chatWidget.ensureVisible(cursorRectangle)
            readOnly                 : true
            textFormat               : TextEdit.RichText
            width                    : page.width
            wrapMode                 : TextEdit.WrapAtWordBoundaryOrAnywhere
            onLinkActivated          : Qt.openUrlExternally(link)
            text                     : "<font color=gray>Welcome to the chat room!</font><br>"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: grid.opacity = 0
        }
    }

    Rectangle {
        id: sendRectangle
        anchors.left  : parent.left
        anchors.right : parent.right
        anchors.bottom: parent.bottom
        height        : smartBorderSize(32)
        color         : "transparent"

        Textbox {
            id                     : sendTextbox

            anchors.left   : parent.left
            anchors.right  : emotesButton.left
            anchors.bottom : parent.bottom
            anchors.top    : parent.top
            anchors.rightMargin: -1

            placeholderText      : qsTr("Type a message...")
            Keys.onReturnPressed : {
                if (text.length > 0) {
                    bridge.sendMessage(sendTextbox.text)
                    sendTextbox.text = ""
                }
            }
        }

        Button {
            id: emotesButton

            anchors.right  : sendButton.left
            anchors.bottom : parent.bottom
            anchors.top    : parent.top

            height : smartBorderSize(32)
            width  : smartBorderSize(32)

            anchors.rightMargin: -1

            Image {
                anchors.horizontalCenter : parent.horizontalCenter
                anchors.verticalCenter   : parent.verticalCenter
                height : smartBorderSize(16)
                width  : smartBorderSize(16)
                source : "qrc:/emotes/smile.png"
            }

            onClicked: {
                if (grid.opacity > 0)
                    grid.opacity = 0
                else
                    grid.opacity = 1
            }
        }

        Button {
            id: sendButton

            anchors.right  : parent.right
            anchors.bottom : parent.bottom
            anchors.top    : parent.top

            width     : smartBorderSize(64)
            height    : smartBorderSize(32)
            text      : qsTr("Send")
            enabled   : sendTextbox.length > 0 ? 1 : 0
            onClicked : {
                bridge.sendMessage(sendTextbox.text)
                sendTextbox.text = ""
            }
        }
    }

    Grid {
        anchors.bottom: sendRectangle.top
        anchors.bottomMargin: 4
        anchors.right: page.right
        anchors.rightMargin: 4
        opacity: 0
        enabled: opacity > 0 ? 1 : 0

        id: grid
        spacing: 8

        Behavior on opacity { NumberAnimation{} }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *ANGEL*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/angel.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *ANGRY*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/angry.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *COOL*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/cool.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *CRYING*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/crying.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *DEVIL*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/devil.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *GRIN*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/happy.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *HEART*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/heart.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *JOYFUL*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/joyful.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *KISSING*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/kissing.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *LOL*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/lol.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *POUTY*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/pouty.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SAD*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/sad.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SICK*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/sick.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SLEEPING*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/sleeping.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SMILE*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/smile.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *PINCHED*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/pinched.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *TONGUE*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/tongue.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *UNCERTAIN*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/uncertain.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *WINK*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/wink.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *WONDERING*"
            height: smartBorderSize(32)
            width: smartBorderSize(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: smartBorderSize(16)
                width: smartBorderSize(16)
                source: "qrc:/emotes/wondering.png"
            }
        }
    }
}
