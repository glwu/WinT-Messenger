//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    height: DeviceManager.ratio(32)
    color: (mouseArea.containsMouse || mouseArea.pressed) ? colors.toolbarColorStatic: "transparent"

    property alias userName: label.text

    Image {
        id: userPicture
        height: width
        width: DeviceManager.ratio(28)
        source: "qrc:/images/ToolbarIcons/Person.png"
        asynchronous: true
        anchors.left: parent.left
        anchors.margins: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    Label {
        id: label
        color: colors.toolbarText
        anchors.left: userPicture.right
        anchors.margins: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    Connections {
        target: Bridge
        onDelUser: user === userName ? destroy(): update()
    }
}
