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
    anchors {fill: parent; leftMargin: mainWindow.width;}
    opacity: anchors.leftMargin < mainWindow.width ? 1 : 0

    Behavior on opacity {NumberAnimation{}}
    Behavior on anchors.leftMargin {NumberAnimation{}}

    Connections {
        target: bridge
        onNewUser: usersList.append({"name": nick, "face": face})
    }

    GridView {
        id: usersGrid
        model: usersList
        cellHeight: device.ratio(72)
        cellWidth: device.ratio(256)
        visible: panel.anchors.leftMargin === 0 ? 1 : 0
        anchors {
            fill: parent
            margins: device.ratio(12)
            topMargin: captionRectangle.y + captionRectangle.height + device.ratio(12)
        }

        delegate: Rectangle {
            width: usersGrid.cellWidth
            height: usersGrid.cellHeight
            color: mouseArea.containsMouse ? colors.darkGray: "transparent"

            Connections {
                target: bridge
                onDelUser:  {
                    if (nick == name)
                        destroy();
                }
            }

            Image {
                height: width
                id: userPicture
                asynchronous: true
                width: device.ratio(64)
                source: "qrc:/faces/" + face
                anchors {
                    left: parent.left
                    margins: device.ratio(4)
                    verticalCenter: parent.verticalCenter
                }
            }

            Label {
                id: label
                text: name
                color: colors.toolbarText
                anchors {
                    right: parent.right
                    left: userPicture.right
                    margins: device.ratio(4)
                    verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: !device.isMobile()
            }
        }
    }

    Rectangle {
        id: captionRectangle
        height: toolbar.height
        opacity: toolbar.opacity
        color: colors.darkGray
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Label {
            opacity: 0.75
            text: qsTr("Users")
            id: userWidgetTitle
            color: colors.toolbarText
            height: device.ratio(48)
            font.pixelSize: sizes.large
            verticalAlignment: Text.AlignVCenter
            anchors {
                left: parent.left
                margins: device.ratio(12)
                verticalCenter: parent.verticalCenter
            }
        }

        Image {
            width: height
            rotation: 180
            id: closeButton
            asynchronous: true
            opacity: panel.opacity
            enabled: panel.enabled
            source: "qrc:/icons/ToolbarIcons/Common/Close.png"
            height: device.ratio(48)
            anchors {
                right: parent.right
                margins: device.ratio(12)
                verticalCenter: parent.verticalCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {panel.anchors.leftMargin = mainWindow.width; usersWidgetEnabled = false;}
            }
        }
    }

    ListModel {id: usersList}
}
