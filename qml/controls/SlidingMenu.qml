//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Controls 1.1 as Controls

Rectangle {
    id: menu
    enabled: false
    opacity: enabled ? 1 : 0
    color: theme.background

    anchors {
        fill: parent
        topMargin: parent.height
    }

    // Enable animations
    Behavior on opacity {NumberAnimation{}}
    Behavior on anchors.topMargin {NumberAnimation{}}

    // Toggle the visibility of the slider menu
    function toggle() {
        if (!enabled)
            menu.anchors.topMargin = menu.parent.height * (1 - 0.45)
        else
            menu.anchors.topMargin = menu.parent.height

        enabled = !enabled
    }

    // Allow the programmer to customize the slider menu
    property bool captionVisible: true
    property alias model: gridView.model
    property alias title: captionText.text
    property alias delegate: gridView.delegate
    property alias cellWidth: gridView.cellWidth
    property alias cellHeight: gridView.cellHeight

    // Add a caption and a close button to the menu
    Rectangle {
        id: captionRectangle
        color: theme.navigationBar
        height: captionVisible ? units.gu(6) : 0
        anchors {left: parent.left; right: parent.right; top: parent.top;}

        // Top border
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: captionVisible ? device.ratio(1) : 0
            color: settings.customColor() ?
                       Qt.lighter(theme.navigationBar, 1.2) :
                       theme.borderColor
        }

        // Bottom border
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: captionVisible ? device.ratio(1) : 0
            color: settings.customColor() ?
                       Qt.lighter(theme.navigationBar, 1.2) :
                       theme.borderColor
        }

        Label {
            id: captionText
            color: theme.navigationBarText
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: units.fontSize("x-large")
            height: captionVisible ? device.ratio(48) : 0

            anchors {
                margins: 12;
                left: parent.left;
                verticalCenter: parent.verticalCenter;
            }
        }

        Button {
            flat: true
            width: height
            id: closeButton
            opacity: opacity
            iconName: "chevron-down"
            height: device.ratio(48)
            textColor: theme.navigationBarText

            anchors {
                right: parent.right;
                margins: device.ratio(12);
                verticalCenter: parent.verticalCenter;
            }

            Behavior on opacity {NumberAnimation{}}

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    menu.anchors.topMargin = menu.parent.height
                }
            }
        }
    }

    // Add a scrollbar to the slider menu
    Controls.ScrollView {
        anchors {
            fill: parent
            topMargin: captionRectangle.height
        }

        Rectangle {
            anchors.fill: parent
            color: theme.panel
        }

        GridView {
            id: gridView
            anchors.centerIn: parent
            anchors.topMargin: device.ratio(6)
            anchors.leftMargin: device.ratio(6)
        }
    }
}
