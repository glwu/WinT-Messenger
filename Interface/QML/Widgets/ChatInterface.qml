//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Item {
    id: page
    anchors.fill: parent

    function setText(text, color) {
        textbox.text = "<font color=" + color + ">" + text + "</font><br>"
    }

    function clearText() {
        textbox.text = ""
    }

    function setTextSize(size) {
        textbox.font.pixelSize = bridge.ratio(size)
    }

    function addUser(user) {
        Qt.createQmlObject(("UserInfo {userName:\"" + user + "\";}"), column, (user + "-userInfo"))
    }

    Component.onCompleted: addUser(qsTr("You") + " (" + settings.value("userName", "unknown") + ")")

    Connections {
        target: bridge
        onNewMessage: textbox.append(text)
        onNewUser: addUser(nick)
    }

    Flickable {
        id: chatWidget

        contentHeight      : textbox.paintedHeight
        interactive        : true
        flickableDirection : Flickable.VerticalFlick

        anchors.margins      : 12
        anchors.bottomMargin : sendRectangle.height + 11

        anchors.left   : parent.left
        anchors.right  : usersWidget.left
        anchors.bottom : parent.bottom
        anchors.top    : parent.top

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
            onCursorRectangleChanged : chatWidget.ensureVisible(cursorRectangle)
            readOnly                 : true
            textFormat               : TextEdit.RichText
            width                    : page.width
            wrapMode                 : TextEdit.WrapAtWordBoundaryOrAnywhere
            onLinkActivated          : Qt.openUrlExternally(link)
            font.pixelSize           : bridge.ratio(16)
        }
    }

    Image {
        id: menuButton

        height : width
        width  : bridge.ratio(32)
        source : "qrc:/images/ToolbarIcons/Group.png"

        anchors.top     : parent.top
        anchors.right   : parent.right
        anchors.margins : 12

        MouseArea {
            anchors.fill: parent
            onClicked: {
                menuButton.opacity = 0
                textbox.wrapMode = TextEdit.NoWrap

                if (page.width >= bridge.ratio(250))
                    usersWidget.width = bridge.ratio(250)
                else
                    usersWidget.width = page.width
            }
        }
    }

    Rectangle {
        id: usersWidget

        anchors.right  : parent.right
        anchors.bottom : parent.bottom
        anchors.top    : parent.top

        anchors.bottomMargin : sendRectangle.height

        color: "#666"
        opacity: 0.8
        width: 0

        Behavior on width { NumberAnimation{} }

        Flickable {
            anchors.fill: parent
            anchors.topMargin: captionRectangle.y + captionRectangle.height + 24

            interactive: true
            flickableDirection: Flickable.VerticalFlick

            Column {
                id: column
                spacing: 8
                anchors.fill: parent
            }

        }

        Rectangle {
            id: captionRectangle
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            height: toolbar.height
            color: colors.toolbarColorStatic

            Text {
                id: userWidgetTitle

                font.pixelSize: sizes.toolbarTitle
                text: qsTr("Users")

                color: colors.toolbarText

                anchors.left: backButton.right
                anchors.margins: 12
                anchors.verticalCenter: parent.verticalCenter

                height: bridge.ratio(48)

                verticalAlignment: Text.AlignVCenter
            }

            Image {
                id: backButton

                anchors.left: parent.left
                anchors.margins: 12

                anchors.verticalCenter: parent.verticalCenter

                source                   : "qrc:/images/ToolbarIcons/Back.png"
                height                   : bridge.ratio(48)
                width                    : height

                rotation: 180

                MouseArea {
                    anchors.fill: parent
                    onClicked: { usersWidget.width = 0; menuButton.opacity = 1; }
                }
            }
        }
    }

    Rectangle {
        id: sendRectangle
        anchors.left   : parent.left
        anchors.right  : parent.right
        anchors.bottom : parent.bottom
        height         : bridge.ratio(32)
        color          : "transparent"

        Button {
            id: attachButton

            anchors.bottom : parent.bottom
            anchors.left   : parent.left
            anchors.top    : parent.top

            width: parent.height
            onClicked: bridge.attachFile()

            Image {
                anchors.horizontalCenter : parent.horizontalCenter
                anchors.verticalCenter   : parent.verticalCenter
                height : width
                width  : bridge.ratio(28)
                source : "qrc:/images/ToolbarIcons/Attach.png"
            }
        }

        Textbox {
            id: sendTextbox

            anchors.left   : attachButton.right
            anchors.right  : emotesButton.left
            anchors.bottom : parent.bottom
            anchors.top    : parent.top

            anchors.rightMargin: -1
            anchors.leftMargin : -1

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

            width: parent.height

            anchors.rightMargin: -1

            Image {
                height : width
                width  : bridge.ratio(16)
                source : "qrc:/emotes/smile.png"

                anchors.horizontalCenter : parent.horizontalCenter
                anchors.verticalCenter   : parent.verticalCenter
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

            width     : bridge.ratio(64)
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
        anchors.bottomMargin: bridge.ratio(4)
        anchors.right: page.right
        anchors.rightMargin: bridge.ratio(4)
        opacity: 0
        enabled: opacity > 0 ? 1 : 0

        id: grid
        spacing: bridge.ratio(4)

        Behavior on opacity { NumberAnimation{} }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *ANGEL*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/angel.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *ANGRY*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/angry.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *COOL*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/cool.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *CRYING*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/crying.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *DEVIL*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/devil.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *GRIN*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/happy.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *HEART*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/heart.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *JOYFUL*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/joyful.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *KISSING*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/kissing.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *LOL*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/lol.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *POUTY*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/pouty.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SAD*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/sad.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SICK*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/sick.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SLEEPING*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/sleeping.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SMILE*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/smile.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *PINCHED*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/pinched.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *TONGUE*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/tongue.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *UNCERTAIN*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/uncertain.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *WINK*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/wink.png"
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *WONDERING*"
            height: bridge.ratio(32)
            width: bridge.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: bridge.ratio(16)
                source: "qrc:/emotes/wondering.png"
            }
        }
    }
}
