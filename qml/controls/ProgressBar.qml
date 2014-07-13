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
    width: device.ratio(48)
    height: device.ratio(12)

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

        // Animate the progress bar when the width changes
        Behavior on width {NumberAnimation{}}
    }

    // Create the background label
    Label {
        text: valueText
        color: theme.textColor
        anchors.centerIn: parent
        font.pixelSize: device.ratio(10)
        horizontalAlignment: Text.AlignLeft
    }

    // Create the foreground label
    Label {
        text: valueText
        anchors.centerIn: parent
        color: theme.navigationBarText
        font.pixelSize: device.ratio(10)
        anchors.horizontalCenterOffset: -(background.width / font.pixelSize / 3)
        width: (paintedWidth * value) / 100
    }
}
