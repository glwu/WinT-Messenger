//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
    smooth:  true
    id: background
    radius: units.scale(2)
    width: units.scale(96)
    height: units.scale(24)
    border.width: units.scale(1)
    border.color: theme.borderColor
    color: theme.textFieldBackground

    property int value: 50
    property string valueText: value + "%"

    Rectangle {
        id: progressRect
        radius: parent.radius
        anchors.top: parent.top
        anchors.left: parent.left
        border.width: units.scale(1)
        anchors.bottom: parent.bottom
        border.color: parent.border.color
        width: (parent.width * value) / 100
        color: theme.getStyleColor("primary")
    }

    Label {
        color: theme.textColor
        anchors.centerIn: parent
        opacity: value >= 55 ? 0 : 1
        font.pixelSize: units.scale(12)
        text: value < 100 ? " " + valueText : valueText
    }

    Label {
        opacity: value / 100
        anchors.centerIn: parent
        color: theme.navigationBarText
        font.pixelSize: units.scale(12)
        text: value < 100 ? " " + valueText : valueText
    }
}
