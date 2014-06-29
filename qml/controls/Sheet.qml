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
import QtGraphicalEffects 1.0

PopupBase {
    id: sheet

    // Create the properties of the sheet
    property bool autosize: false
    property bool confirmButton: true
    property int margins: units.gu(1)
    property int spacing: units.gu(1)
    property bool buttonsEnabled: true
    property string titleFontSize: "x-large"
    property int minHeight: units.gu(60)
    property int horizPadding: units.gu(2)
    property alias __leftButton: leftButton
    property alias __rightButton: rightButton
    property int titleAlignment: Qt.AlignCenter
    property int footerAlignment: Qt.AlignRight
    property int contentHeight: units.gu(40)
    property alias title: titleLabel.text
    default property alias data: contents.data
    property int maxHeight: sheet.parent.height - units.gu(4)

    // Create the values used for the colors
    property color background
    property color titleColor
    property color borderColor

    // Create the signals (for onAccepted() & onRejected())
    signal accepted
    signal rejected

    // Update the colors when the theme changes
    Connections {
        target: theme
        onThemeChanged: {
            background = theme.background
            titleColor = theme.navigationBarText
            borderColor = settings.customColor() ? Qt.lighter(theme.navigationBar, 1.2) : theme.borderColor
        }
    }

    function defaultAction() {
        for (var i = 0; i < footer.children.length; i++) {
            if (footer.children[i].hasOwnProperty("primary") && footer.children[i].primary) {
                footer.children[i].clicked(footer.children[i])
            }
        }
    }

    // Setup the properties of the widget
    z: 2
    radius: units.gu(0.7)
    anchors.centerIn: parent
    overlayColor: Qt.rgba(0,0,0,0.4)
    anchors.verticalCenterOffset: -units.gu(3)
    width: parent.width * 0.95 > units.gu(60) ? units.gu(60) : parent.width * 0.95
    height: Math.min(Math.max(minHeight, contentHeight + titleBar.height + 2 * sheet.margins), maxHeight)

    Behavior on opacity {NumberAnimation{}}

    // Create the shadow
    RectangularGlow {
        id: glowEffect
        opacity: 0.5
        anchors.fill: parent
        glowRadius: units.gu(2)
        color: "black"
    }

    // Create the bakckground
    Rectangle {
        anchors.fill: parent
        radius: sheet.radius
        color: sheet.background
        border.color: borderColor
        border.width: device.ratio(1)
    }

    // Create the titlebar
    Item {
        clip: true
        id: titleBar
        height: titleLabel.height + 2 * units.gu(1.5)

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        // Create the background color
        Rectangle {
            anchors.fill: parent
            anchors.bottomMargin: -radius
            color: theme.navigationBar
            radius: sheet.radius
            border.color: borderColor
        }

        // Create the title label
        Label {
            id: titleLabel
            fontSize: titleFontSize
            color: titleColor
            anchors.centerIn: parent
        }

        // Create the left button
        Button {
            flat: true
            id: leftButton
            textColor: titleColor
            iconName: confirmButton ? "cancel" : "confirm"

            enabled: buttonsEnabled
            visible: buttonsEnabled

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: units.gu(1)
            }

            onClicked: {
                sheet.close()
                confirmButton ? accepted() : rejected()
            }
        }

        // Create the right button
        Button {
            flat: true
            id: rightButton
            iconName: "confirm"
            textColor: titleColor

            enabled: buttonsEnabled
            visible: buttonsEnabled ? confirmButton : 0

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: units.gu(1)
            }

            onClicked: {
                sheet.close()
                accepted()
            }
        }

        // Create the border
        Rectangle {
            height: device.ratio(1)
            color: borderColor

            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
        }
    }

    // Create the contents item
    Item {
        id: contents

        anchors {
            left: parent.left
            right: parent.right
            top: titleBar.bottom
            bottom: parent.bottom
            margins: sheet.margins
        }
    }

    // Close the dialog when ESCAPE is pressed
    Keys.onEscapePressed: sheet.close()
}
