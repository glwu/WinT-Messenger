//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Rectangle {
    // Fill the main window
    x: 0
    y: 0
    width: mainWindow.width
    height: mainWindow.height

    // Set the color and opacity of the background
    color: "#80000000"
    opacity: menu.opacity

    // Disable the background if the menu is not visible
    enabled: menu.opacity > 0 ? 1 : 0

    // Custom properties of the dialog
    property Item contents
    property alias dWidth: menu.width
    property alias dHeight: menu.height
    property bool closeOnBackgroundClicked: true

    // This mouse area is used to hide the dialog when we press anywhere outside
    // the dialog (the dark area).
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (closeOnBackgroundClicked)
                hide()
        }
    }

    // Show the menu with a nice fade animation
    function show() {
        menu.opacity = 1
    }

    // Hide the menu with a nice fade animation
    function hide() {
        menu.opacity = 0
    }

    // This is the actual dialog, where the contents are drawn
    Rectangle {
        id: menu
        opacity: 0
        anchors.centerIn: parent
        color: colors.background
        border.color: colors.borderColor

        // This mouse area avoids hiding the dialog when we click it
        MouseArea {anchors.fill: parent}

        // This behavior allows us to have a nice fading animation
        Behavior on opacity {NumberAnimation{duration: 250}}

        // This rectangle is used to create a border around the dialog
        Rectangle {
            color: "transparent"
            anchors.fill: parent
            border.width: device.ratio(2)
            border.color: Qt.lighter(parent.color, 1.2)
        }

        // This rectangle is used to create a border around the dialog
        Rectangle {
            color: "transparent"
            anchors.fill: parent
            border.width: device.ratio(1)
            border.color: Qt.darker(parent.color, 1.6)
        }

        // This is where we draw the contents of the dialog
        Item {
            x: 0
            y: 0
            children: contents
            width: parent.width
            height: parent.height
        }
    }
}
