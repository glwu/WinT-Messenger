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
    property string iconPath
    property bool emotesRectangleEnabled: false
    property bool usersWidgetEnabled: false

    onWidthChanged: {
        if (!usersWidgetEnabled)
            usersWidget.anchors.leftMargin = width
   }

    onHeightChanged: {
        if (!emotesRectangleEnabled)
            emotesRectangle.anchors.topMargin = height
   }

    Component.onCompleted: {
        iconPath = Settings.darkInterface() ? "qrc:/images/ToolbarIcons/Light/" : "qrc:/images/ToolbarIcons/Dark/"
        usersList.append({"name" : (qsTr("You") + " (" + Settings.value("userName", "unknown") + ")")})
   }

    Connections {
        target: Bridge
        onNewUser: usersList.append({"name": nick})
        onDelUser: usersList.remove({"name": nick})
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
        anchors.fill: parent
        clip: true
        anchors.margins: 12

        TextEdit {
            id: textbox
            width: page.width
            anchors.fill: parent
            color: colors.text
            textFormat: TextEdit.RichText
            wrapMode: TextEdit.WordWrap
            renderType: Text.NativeRendering
            font.family: defaultFont
            font.pixelSize: DeviceManager.ratio(14)
            readOnly: true
            activeFocusOnPress: false
            clip: true
       }
   }

    Image {
        id: menuButton
        height: width
        width: DeviceManager.ratio(48)
        source: iconPath + "Grid.png"
        asynchronous: true
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 12

        MouseArea {
            anchors.fill: parent
            onClicked: {
                usersWidgetEnabled = true
                usersWidget.anchors.leftMargin = 0
           }
       }
   }

    Rectangle {
        id: emotesRectangle
        anchors.fill: parent
        anchors.topMargin: parent.height
        anchors.bottomMargin: sendRectangle.height
        color: "#444"
        opacity: emotesRectangle.anchors.topMargin < page.height ? 1 : 0
        enabled: emotesRectangleEnabled
        Behavior on opacity {NumberAnimation{}}
        Behavior on anchors.topMargin {NumberAnimation{}}

        GridView {
            anchors.fill: parent
            anchors.topMargin: emotesCaptionRectangle.y + emotesCaptionRectangle.height + anchors.margins
            anchors.margins: 12
            cellHeight: DeviceManager.ratio(36)
            cellWidth: cellHeight
            model: emotesModel
            delegate: Rectangle {
                height: DeviceManager.ratio(32)
                width: height
                color: emotesMouseArea.containsMouse ? colors.toolbarColorStatic : "transparent"

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    height: width
                    width: DeviceManager.ratio(16)
                    source: "qrc:/emotes/" + name + ".png"
                    asynchronous: true
               }

                MouseArea {
                    id: emotesMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: sendTextbox.text = sendTextbox.text + "*" + name + "*"
               }
           }

            ListModel {
                id: emotesModel
                ListElement {name: "alien"}
                ListElement {name: "angry"}
                ListElement {name: "angel"}
                ListElement {name: "cool"}
                ListElement {name: "crying"}
                ListElement {name: "devil"}
                ListElement {name: "grin"}
                ListElement {name: "heart"}
                ListElement {name: "joyful"}
                ListElement {name: "kissing"}
                ListElement {name: "lol"}
                ListElement {name: "angry"}
                ListElement {name: "pouty"}
                ListElement {name: "sad"}
                ListElement {name: "sick"}
                ListElement {name: "angry"}
                ListElement {name: "sleeping"}
                ListElement {name: "smile"}
                ListElement {name: "pinched"}
                ListElement {name: "tongue"}
                ListElement {name: "uncertain"}
                ListElement {name: "grin"}
                ListElement {name: "wink"}
                ListElement {name: "wondering"}
           }
       }

        Rectangle {
            id: emotesCaptionRectangle
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: toolbar.height
            color: colors.toolbarColorStatic
            opacity: toolbar.opacity

            Label {
                font.pixelSize: sizes.toolbarTitle
                text: qsTr("Emotes")
                color: colors.toolbarText
                anchors.left: parent.left
                anchors.margins: 12
                anchors.verticalCenter: parent.verticalCenter
                height: DeviceManager.ratio(48)
                verticalAlignment: Text.AlignVCenter
           }

            Image {
                id: emotesCloseButton
                anchors.right: parent.right
                anchors.margins: 12
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/ToolbarIcons/Common/Close.png"
                height: DeviceManager.ratio(48)
                width: height
                rotation: 180
                asynchronous: true
                opacity: emotesRectangle.opacity
                enabled: emotesRectangle.enabled

                Behavior on opacity {NumberAnimation{}}

                MouseArea {
                    anchors.fill: parent
                    onClicked: {emotesButton.enabled = true; emotesRectangle.anchors.topMargin = page.height; emotesRectangleEnabled = false;}
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
                width: DeviceManager.ratio(32)
                source: iconPath + "Attach.png"
                asynchronous: true
           }
       }

        Button {
            id: btButton
            anchors.bottom: parent.bottom
            anchors.left: attachButton.right
            anchors.top: parent.top
            anchors.leftMargin: -1
            width: visible ? parent.height : 0
            onClicked: Bridge.showBtSelector()
            enabled: Bridge.btChatEnabled()
            visible: enabled

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: parent.visible ? DeviceManager.ratio(32) : 0
                source: iconPath + "Bluetooth.png"
                asynchronous: true
           }
       }

        Textbox {
            id: sendTextbox
            anchors.left: btButton.right
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
                enabled: parent.enabled
           }

            onClicked: {
                enabled = false
                emotesRectangleEnabled = true
                emotesRectangle.anchors.topMargin = page.height / 2
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

    Rectangle {
        id: usersWidget
        anchors.fill: parent
        anchors.leftMargin: page.width
        color: "#444"
        opacity: anchors.leftMargin < page.width ? 1 : 0
        enabled: usersWidgetEnabled
        Behavior on opacity {NumberAnimation{}}
        Behavior on anchors.leftMargin {NumberAnimation{}}
        ListModel {id: usersList}

        GridView {
            id: usersGrid
            anchors.fill: parent
            anchors.topMargin: captionRectangle.y + captionRectangle.height + anchors.margins
            anchors.margins: 12
            cellHeight: DeviceManager.ratio(72)
            cellWidth: DeviceManager.ratio(256)
            visible: usersWidget.anchors.leftMargin === 0 ? 1 : 0
            model: usersList
            delegate: Rectangle {
                color: mouseArea.containsMouse ? colors.toolbarColorStatic: "transparent"
                height: usersGrid.cellHeight
                width: usersGrid.cellWidth

                Connections {
                    target: Bridge
                    onDelUser:  {
                        if (nick == label.text)
                            destroy();
                   }
               }

                Image {
                    id: userPicture
                    height: width
                    width: DeviceManager.ratio(64)
                    source: "qrc:/images/ToolbarIcons/Common/Person.png"
                    asynchronous: true
                    anchors.left: parent.left
                    anchors.margins: DeviceManager.ratio(4)
                    anchors.verticalCenter: parent.verticalCenter
               }

                Label {
                    id: label
                    text: name
                    color: colors.toolbarText
                    anchors.left: userPicture.right
                    anchors.right: parent.right
                    anchors.margins: DeviceManager.ratio(4)
                    anchors.verticalCenter: parent.verticalCenter
               }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
               }
           }
       }

        Rectangle {
            id: captionRectangle
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: toolbar.height
            color: colors.toolbarColorStatic
            opacity: toolbar.opacity

            Label {
                id: userWidgetTitle
                font.pixelSize: sizes.toolbarTitle
                text: qsTr("Users")
                color: colors.toolbarText
                anchors.left: parent.left
                anchors.margins: 12
                anchors.verticalCenter: parent.verticalCenter
                height: DeviceManager.ratio(48)
                verticalAlignment: Text.AlignVCenter
                opacity: 0.75
           }

            Image {
                id: closeButton
                anchors.right: parent.right
                anchors.margins: 12
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/ToolbarIcons/Common/Close.png"
                height: DeviceManager.ratio(48)
                width: height
                rotation: 180
                asynchronous: true
                opacity: usersWidget.opacity
                enabled: usersWidget.enabled
                Behavior on opacity {NumberAnimation{}}
                MouseArea {
                    anchors.fill: parent
                    onClicked: {usersWidget.anchors.leftMargin = page.width; usersWidgetEnabled = false;}
               }
           }
       }
   }
}
