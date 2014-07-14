//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

//--------------------------------------------------//
// This object represents a progressbar, that's all.//
//--------------------------------------------------//

Rectangle {
    smooth: true
    id: background

    // Set the size of the progress bar
    width: device.ratio(96)
    height: device.ratio(24)

    // Set the background color
    color: theme.textFieldBackground

    // Set the border color
    border.color: theme.borderColor

    // Make the progressbar be slightly rounded
    radius: device.ratio(2)

    // Allow the programmer to define the progress (it can be from 0 to 100)
    property int value: 50
    property string valueText: value + "%"

    // Create the progress rectangle
    Rectangle {
        id: progressRect

        // Set the anchors
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        // Set the background color
        color: theme.getStyleColor("primary")

        // Set the border color
        border.color: parent.border.color

        // Have the same radius as the background
        radius: parent.radius

        // Set the width
        width: (parent.width * value) / 100
    }

    // Create the background label
    Label {
        color: theme.textColor
        anchors.centerIn: parent
        opacity: value >= 55 ? 0 : 1
        font.pixelSize: device.ratio(12)
        text: value < 100 ? " " + valueText : valueText
    }

    // Create the foreground label
    Label {
        opacity: value / 100
        anchors.centerIn: parent
        color: theme.navigationBarText
        font.pixelSize: device.ratio(12)
        text: value < 100 ? " " + valueText : valueText
    }
}
