//
//  This file is part of Leaf Tips
//
//  Copyright (c) 2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
    id: button

    // Make the button semi-transparent
    opacity: 0.85

    // Set the background color of the button
    color: colors.buttonBackground

    // Set the border color of the button
    border.color: colors.borderColor

    // Have a consisted height/width ratio
    height: 1.9 * label.height
    width: label.width > (6 * height) ? (1.5 * label.width) : (6 * height)

    // Allow the programmer to use the onClicked() function
    signal clicked

    // Allow the programmer to change the caption of the button
    property alias text: label.text

    // This rectangle allows the button to change is color if the
    // mouse area is hovered or pressed.
    Rectangle {
        anchors.fill: parent

        // Change the border color
        border.color: mouseArea.containsMouse || mouseArea.pressed ?
                          colors.userColor : colors.borderColor

        // Change the color
        color: {
            if (mouseArea.containsMouse || mouseArea.pressed)
                return colors.userColor
            else if (!button.enabled)
                return colors.buttonBackgroundDisabled
            else
                return colors.buttonBackground
        }

        // Fade between colors
        Behavior on color {ColorAnimation{}}

        // Make the button "stand out" when pressed
        opacity: mouseArea.pressed ? 0.2 : 0.1
    }

    // The mouse area allows the button to change its appearance and to
    // emit the clicked() signal when pressed.
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: !device.isMobile()
        onClicked: button.clicked()
    }

    // This label is used to draw the caption of the button
    Label {
        id: label
        anchors.centerIn: parent
        color: parent.enabled ? colors.buttonForeground :
                                colors.buttonForegroundDisabled
    }
}
