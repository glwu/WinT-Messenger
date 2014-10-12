//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Frame {
    id: button
    signal clicked

    property string style
    property bool primary
    property color textColor
    property bool flat: false
    property color background
    property color borderColor
    property bool toggled: false
    property alias text: label.text
    property bool toggleButton: false
    property alias iconName: icon.name
    property int minWidth: units.gu(10)
    property color background_mouseOver
    property int horizPadding: units.gu(2)
    property alias fontSize: label.fontSize

    function updateColors() {
        borderColor = theme.borderColor
        background = style === "default" ? theme.panel : theme.getStyleColor(style)
        background_mouseOver = style == "default" ? Qt.darker(background, 1.05) : Qt.darker(background, 1.15)
        textColor = settings.darkInterface() ? theme.navigationBarText : style === "default" ? theme.textColor : "white"
    }

    Connections {
        target: theme
        onThemeChanged: updateColors()
    }

    Component.onCompleted: updateColors()

    height: units.gu(4)
    opacity: enabled ? 1 : 0.5
    style: primary ? "primary" : "default"
    border.color: {
        if (flat)
            return "transparent"

        return borderColor
    }

    width: text === "" ? height : Math.max(minWidth, row.width + 2 * horizPadding)

    color: {
        if (flat)
            return "transparent"
        else {
            if (mouseArea.containsMouse || toggled)
                return background_mouseOver
            else
                return background
        }
    }

    Row {
        id: row
        spacing: units.gu(1)

        anchors {
            leftMargin: units.gu(1)
            left: flat ? parent.left : undefined
            verticalCenter: parent.verticalCenter
            horizontalCenter: flat ? undefined : parent.horizontalCenter
        }

        Icon {
            id: icon
            color: button.textColor
            fontSize: units.scale(24)
            anchors.verticalCenterOffset: units.scale(1)
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            id: label
            color: button.textColor
            font.pixelSize: units.scale(13.4)
            anchors.verticalCenterOffset: units.scale(1)
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: !app.mobileDevice
        onClicked: {
            button.clicked()
            toggleButton ? toggled = !toggled : undefined
        }
    }
}
