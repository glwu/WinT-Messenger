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

    function setText(text, color) {textbox.text = "<font color=" + color + ">" + text + "</font><br>"}
    function clearText()          {textbox.text = ""}
    function setTextSize(size)    {textbox.font.pixelSize = DeviceManager.ratio(size)}
    function addUser(user)        {Qt.createQmlObject(("UserInfo {userName:\"" + user + "\";}"), column, (user + "-userInfo"))}

    Component.onCompleted: addUser(qsTr("You") + " (" + Settings.value("userName", "unknown") + ")")

    Connections {
        target: Bridge
        onNewUser: addUser(nick)
        onNewMessage: {
            textbox.append(text)
            if (textbox.lineCount > textbox.cursorPosition)
                textbox.cursorPosition = textbox.lineCount
        }
    }

    Flickable {
        id: chatWidget
        contentHeight: textbox.paintedHeight
        interactive: true
        flickableDirection: Flickable.VerticalFlick
        anchors.margins: 12
        anchors.bottomMargin: sendRectangle.height + 11
        anchors.left: parent.left
        anchors.right: usersWidget.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        clip: true

        TextEdit {
            id: textbox
            width: page.width
            anchors.fill: parent
            color: colors.text
            textFormat: TextEdit.RichText
            wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
            renderType: Text.NativeRendering
            font.family: defaultFont
            font.pixelSize: DeviceManager.ratio(16)
            readOnly: true
            activeFocusOnPress: false
            clip: true
        }
    }

    Image {
        id: menuButton

        height: width
        width: DeviceManager.ratio(32)
        source: "qrc:/images/ToolbarIcons/Group.png"
        asynchronous: true

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 12

        MouseArea {
            anchors.fill: parent
            onClicked: {
                menuButton.opacity = 0

                if (page.width >= DeviceManager.ratio(250))
                    usersWidget.width = DeviceManager.ratio(250)
                else
                    usersWidget.width = page.width
            }
        }
    }

    Rectangle {
        id: usersWidget
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.bottomMargin: sendRectangle.height
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

            Label {
                id: userWidgetTitle
                font.pixelSize: sizes.toolbarTitle
                text: qsTr("Users")
                color: colors.toolbarText
                anchors.left: backButton.right
                anchors.margins: 12
                anchors.verticalCenter: parent.verticalCenter
                height: DeviceManager.ratio(48)
                verticalAlignment: Text.AlignVCenter
            }

            Image {
                id: backButton
                anchors.left: parent.left
                anchors.margins: 12
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/ToolbarIcons/Back.png"
                height: DeviceManager.ratio(48)
                width: height
                rotation: 180
                asynchronous: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: { usersWidget.width = 0; menuButton.opacity = 1; }
                }
            }
        }
    }

    Rectangle {
        id: sendRectangle
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: DeviceManager.ratio(32)
        color: "transparent"

        Button {
            id: attachButton
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.height
            onClicked: Bridge.attachFile()

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(28)
                source: "qrc:/images/ToolbarIcons/Attach.png"
            }
        }

        Textbox {
            id: sendTextbox
            anchors.left: attachButton.right
            anchors.right: emotesButton.left
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.rightMargin: -1
            anchors.leftMargin: -1
            placeholderText: qsTr("Type a message...")

            Keys.onReturnPressed: {
                if (text.length > 0) {
                    Bridge.sendMessage(sendTextbox.text)
                    sendTextbox.text = ""
                }
            }
        }

        Button {
            id: emotesButton
            anchors.right: sendButton.left
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            width: parent.height
            anchors.rightMargin: -1

            Image {
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/smile.png"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
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
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            width: DeviceManager.ratio(64)
            text: qsTr("Send")
            enabled: sendTextbox.length > 0 ? 1: 0
            onClicked: {
                Bridge.sendMessage(sendTextbox.text)
                sendTextbox.text = ""
            }
        }
    }

    Grid {
        id: grid
        anchors.bottom: sendRectangle.top
        anchors.bottomMargin: DeviceManager.ratio(4)
        anchors.right: page.right
        anchors.rightMargin: DeviceManager.ratio(4)
        opacity: 0
        enabled: opacity > 0 ? 1: 0
        spacing: DeviceManager.ratio(4)

        Behavior on opacity { NumberAnimation{} }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *ANGEL*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/angel.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *ANGRY*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/angry.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *COOL*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/cool.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *CRYING*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/crying.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *DEVIL*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/devil.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *GRIN*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/happy.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *HEART*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/heart.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *JOYFUL*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/joyful.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *KISSING*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/kissing.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *LOL*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/lol.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *POUTY*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/pouty.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SAD*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/sad.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SICK*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/sick.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SLEEPING*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/sleeping.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *SMILE*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/smile.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *PINCHED*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/pinched.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *TONGUE*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/tongue.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *UNCERTAIN*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/uncertain.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *WINK*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/wink.png"
                asynchronous: true
            }
        }

        Button {
            onClicked: sendTextbox.text = sendTextbox.text + " *WONDERING*"
            height: DeviceManager.ratio(32)
            width: DeviceManager.ratio(32)

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/wondering.png"
                asynchronous: true
            }
        }
    }
}
