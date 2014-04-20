//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
    id: panel
    color: "#444"
    enabled: usersWidgetEnabled
    anchors {fill: parent; leftMargin: masterWidth;}
    opacity: anchors.leftMargin < masterWidth ? 1 : 0

    Behavior on opacity {NumberAnimation{}}
    Behavior on anchors.leftMargin {NumberAnimation{}}

    property int masterWidth: parent.width

    function addUser(name) {
        usersList.append({"name": name})
    }

    ListModel {id: usersList}

    Connections {
        target: Bridge
        onNewUser: usersList.append({"name": nick})
        onDelUser: usersList.remove({"name": nick})
    }

    GridView {
        id: usersGrid
        model: usersList
        cellHeight: DeviceManager.ratio(72)
        cellWidth: DeviceManager.ratio(256)
        visible: panel.anchors.leftMargin === 0 ? 1 : 0
        anchors {fill: parent; topMargin: captionRectangle.y + captionRectangle.height + 12; margins: 12;}

        delegate: Rectangle {
            width: usersGrid.cellWidth
            height: usersGrid.cellHeight
            color: mouseArea.containsMouse ? colors.toolbarColorStatic: "transparent"

            Connections {
                target: Bridge
                onDelUser:  {
                    if (nick == label.text)
                        destroy();
                }
            }

            Image {
                height: width
                id: userPicture
                asynchronous: true
                width: DeviceManager.ratio(64)
                source: "qrc:/images/ToolbarIcons/Common/Person.png"
                anchors {left: parent.left; margins: DeviceManager.ratio(4); verticalCenter: parent.verticalCenter;}
            }

            Label {
                id: label
                text: name
                color: colors.toolbarText
                anchors {left: userPicture.right; right: parent.right; margins: DeviceManager.ratio(4); verticalCenter: parent.verticalCenter;}
            }

            MouseArea {
                id: mouseArea
                hoverEnabled: true
                anchors.fill: parent
            }
        }
    }

    Rectangle {
        id: captionRectangle
        height: toolbar.height
        opacity: toolbar.opacity
        color: colors.toolbarColorStatic
        anchors {left: parent.left; right: parent.right; top: parent.top;}

        Label {
            opacity: 0.75
            text: qsTr("Users")
            id: userWidgetTitle
            color: colors.toolbarText
            height: DeviceManager.ratio(48)
            font.pixelSize: sizes.toolbarTitle
            verticalAlignment: Text.AlignVCenter
            anchors {left: parent.left; margins: 12; verticalCenter: parent.verticalCenter;}
        }

        Image {
            width: height
            rotation: 180
            id: closeButton
            asynchronous: true
            opacity: panel.opacity
            enabled: panel.enabled
            source: "qrc:/images/ToolbarIcons/Common/Close.png"
            height: DeviceManager.ratio(48)
            anchors {right: parent.right; margins: 12; verticalCenter: parent.verticalCenter;}

            MouseArea {
                anchors.fill: parent
                onClicked: {panel.anchors.leftMargin = masterWidth; usersWidgetEnabled = false;}
            }
        }
    }
}
