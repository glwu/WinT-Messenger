//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"

import QtQuick 2.0

Dialog {
    id: _news
    title: qsTr("News")

    contents: Item {
        anchors.centerIn: parent

        Icon {
            name: "fa-spinner"
            iconSize: units.gu(12)
            color: theme.textColor
            anchors.centerIn: parent
            onRotationChanged: rotation += 60
            Component.onCompleted: rotation = 1
            Behavior on rotation {NumberAnimation{}}
        }
    }
}
