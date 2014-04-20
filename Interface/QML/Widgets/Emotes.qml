//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
    color: "#444"
    id: emotesPanel
    enabled: emotesRectangleEnabled
    opacity: emotesPanel.anchors.topMargin < pageHeight ? 1 : 0
    anchors {fill: parent; topMargin: parent.height; bottomMargin: sendRectangle.height;}

    Behavior on opacity {NumberAnimation{}}
    Behavior on anchors.topMargin {NumberAnimation{}}

    property int pageHeight: parent.height

    GridView {
        model: emotesModel
        cellWidth: cellHeight
        cellHeight: DeviceManager.ratio(36)
        anchors {fill: parent; margins: 12;
            topMargin: emotesCaptionRectangle.y + emotesCaptionRectangle.height + anchors.margins;}

        delegate: Rectangle {
            width: height
            height: DeviceManager.ratio(32)
            color: emotesMouseArea.containsMouse ? colors.toolbarColorStatic : "transparent"

            Image {
                height: width
                asynchronous: true
                width: DeviceManager.ratio(16)
                source: "qrc:/emotes/" + name + ".png"
                anchors {horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter;}
            }

            MouseArea {
                hoverEnabled: true
                id: emotesMouseArea
                anchors.fill: parent
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
        height: toolbar.height
        opacity: toolbar.opacity
        id: emotesCaptionRectangle
        color: colors.toolbarColorStatic
        anchors {left: parent.left; right: parent.right; top: parent.top;}

        Label {
            text: qsTr("Emotes")
            color: colors.toolbarText
            height: DeviceManager.ratio(48)
            font.pixelSize: sizes.toolbarTitle
            verticalAlignment: Text.AlignVCenter
            anchors {left: parent.left; margins: 12; verticalCenter: parent.verticalCenter;}
        }

        Image {
            width: height
            asynchronous: true
            id: emotesCloseButton
            opacity: emotesPanel.opacity
            enabled: emotesPanel.enabled
            height: DeviceManager.ratio(48)
            source: "qrc:/images/ToolbarIcons/Common/Close.png"
            anchors {right: parent.right; margins: 12; verticalCenter: parent.verticalCenter;}

            Behavior on opacity {NumberAnimation{}}

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    emotesButton.enabled = true
                    emotesRectangleEnabled = false
                    emotesPanel.anchors.topMargin = pageHeight
                }
            }
        }
    }
}
