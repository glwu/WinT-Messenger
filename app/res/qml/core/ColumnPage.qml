//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../controls"
import QtQuick 2.3
import QtGraphicalEffects 1.0

Page {
    property string iconName
    property alias source: _image.source
    property alias caption: _caption.text
    property alias subtitle: _subtitle.text
    default property alias contents: _contents.data

    RectangularGlow {
        opacity: 0.2
        width: _bg.width
        height: _bg.height
        anchors.centerIn: _bg
        glowRadius: units.scale(3)
        anchors.verticalCenterOffset: glowRadius
        anchors.horizontalCenterOffset: glowRadius
        color: settings.darkInterface() ? theme.shadow : theme.borderColor
    }

    Rectangle {
        color: theme.dialog
        anchors.fill: parent
        id: fallbackRectangle
        opacity: app.width < 1.25 * _bg.width ? 1 : 0

        Rectangle {
            height: units.scale(1)
            color: theme.borderColor
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Rectangle {
            height: units.scale(1)
            color: theme.borderColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

        Behavior on opacity {NumberAnimation{}}
    }

    Rectangle {
        id: _bg
        color: theme.dialog
        height: 1.125 * width
        anchors.centerIn: parent
        border.width: units.scale(1)
        anchors.margins: units.scale(24)
        width: _image.width + units.gu(32)
        border.color: fallbackRectangle.opacity > 0 ? "transparent" : theme.borderColor

        Label {
            id: _caption
            fontSize: "xx-large"
            color: theme.logoTitle
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -units.scale(12)
        }

        Label {
            id: _subtitle
            fontSize: "medium"
            color: theme.logoSubtitle
            anchors.top: _caption.bottom
            anchors.margins: units.scale(6)
            centered: true
        }

        Image {
            id: _image
            width: height
            height: units.scale(128)
            anchors.bottom: _caption.top
            anchors.margins: units.scale(12)
            sourceSize: Qt.size(height, width)
            anchors.horizontalCenter: parent.horizontalCenter

            Icon {
                name: iconName
                visible: iconName
                anchors.fill: parent
                color: theme.iconColor
                iconSize: _image.height
            }
        }

        Item {
            id: _contents

            anchors {
                left: parent.left
                right: parent.right
                top: _subtitle.bottom
                bottom: parent.bottom
                margins: units.scale(12)
            }
        }
    }
}
