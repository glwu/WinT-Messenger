//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"

import QtQuick 2.3

Dialog {
    id: message

    property alias icon: _icon.name
    property alias caption: _title.text
    property alias details: _subtitle.text
    default property alias data: _contents.data

    contents: Item {
        anchors.fill: parent
        anchors.margins: units.gu(1.2)

        Icon {
            id: _icon
            color: theme.iconColor
            iconSize: units.gu(14)
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -height / 1.2
        }

        Label {
            id: _title
            fontSize: "x-large"
            maximumLineCount: 1
            elide: Text.ElideRight
            anchors.top: _icon.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            id: _subtitle
            fontSize: "medium"
            maximumLineCount: 1
            elide: Text.ElideRight
            anchors.top: _title.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            id: _contents
            anchors.top: _subtitle.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: units.gu(6)
            anchors.margins: units.scale(16)
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
