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
    height: units.gu(4)
    color: "transparent"
    radius: units.scale(2)
    opacity: enabled ? 1 : 0.5
    border.color: "transparent"
    style: primary ? "primary" : "default"
    width: text === "" ? height : Math.max(units.gu(10), row.width + 2 * units.gu(2))

    signal clicked

    property string style
    property bool primary
    property string textColor
    property bool flat: false
    property bool toggled: false
    property alias text: label.text
    property bool toggleButton: false
    property alias iconName: icon.name
    property alias fontSize: label.fontSize

    function updateColors() {
        textColor = style === "default" ? theme.textColor : "white"
    }

    Component.onCompleted: updateColors()

    Behavior on opacity {NumberAnimation{}}

    Connections {
        target: theme
        onThemeChanged: updateColors()
    }

    Rectangle {
        smooth: true
        visible: !flat
        anchors.fill: parent
        radius: parent.radius
        border.color: "#D4DCE3"
        border.width: units.scale(1)

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FEFEFE" }
            GradientStop { position: 1.0; color: "#F8F8F8" }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: primary ? theme.primary : theme.secondary

        opacity: {
            if (!flat && (primary || style == "primary"))
                return 1.0
            else if (mouseArea.containsMouse && !flat)
                return 0.1
            else
                return 0.0
        }

        Behavior on color {ColorAnimation{}}
        Behavior on opacity {NumberAnimation{}}
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
