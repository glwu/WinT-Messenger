/*
 * QML Air - A lightweight and mostly flat UI widget collection for QML
 * Copyright (C) 2014 Michael Spencer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2

Widget {
    id: button

    // Create the color properties
    property color iconColor: textColor
    property color textColor
    property color background
    property color background_mouseOver
    property color borderColor

    // Create the size properties
    property int horizPadding: units.gu(2)
    property int minWidth: units.gu(10)

    // Create the style properties
    property bool primary
    property bool selected
    property bool hidden
    property bool flat: false
    property bool modified: false

    // Create the text and iconName properties
    property alias text: label.text
    property alias iconName: icon.name

    // Update the colors of the widget when the theme changes
    Connections {
        target: theme
        onThemeChanged: {
            if (!flat && !modified) {
                textColor = style === "default" ? theme.textColor : "white"
                background = style === "default" ? theme.buttonBackground : theme.getStyleColor(style)
                background_mouseOver = style == "default" ? Qt.darker(background, 1.1) : Qt.darker(background, 1.15)
                borderColor = theme.borderColor
            }
        }
    }

    // Set the size and style of the button
    height: units.gu(4)
    radius: units.gu(0.25)
    style: primary ? "primary" : "default"
    width: text === "" ? height : Math.max(minWidth, row.width + 2 * horizPadding)

    // Set the opacity of the button based on the state of the button
    opacity: enabled ? 1 : 0.5

    // Set the color of the button and its border based on its state
    border.width: device.ratio(1)
    border.color: !flat && (mouseOver || !hidden) ? borderColor : "transparent"
    color: {
        if (flat)
            return "transparent"
        else if (selected || mouseOver)
            return background_mouseOver
        else
            return background
    }

    // Play some animations while changing states
    Behavior on opacity {NumberAnimation {}}

    // Create a row with the icon and the text
    Row {
        id: row

        // Center the row
        anchors.centerIn: parent

        // Set a spacing of 8 pixels between the icon and the text
        spacing: units.gu(1)

        // Create the icon
        Icon {
            id: icon
            color: button.iconColor
            fontSize: device.ratio(24)
            anchors.verticalCenter: parent.verticalCenter
        }

        // Create the text
        Label {
            id: label
            color: button.textColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
