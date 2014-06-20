//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Controls 1.1

Rectangle {
    id: menu
    color: "#444"
    enabled: false
    opacity: enabled ? 1 : 0

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
            menu.anchors.topMargin = pageHeight / 2
        else
            menu.anchors.topMargin = pageHeight

        enabled = !enabled
    }

    // Allow the programmer to customize the slider menu
    property alias model: gridView.model
    property int pageHeight: parent.height
    property alias title: captionText.text
    property alias delegate: gridView.delegate
    property alias cellWidth: gridView.cellWidth
    property alias cellHeight: gridView.cellHeight

    // Add a scrollbar to the slider menu
    ScrollView {
        anchors {
            fill: parent
            margins: device.ratio(6)
            topMargin: captionRectangle.height + device.ratio(12)
        }

        GridView {
            id: gridView
            anchors {
                fill: parent
            }
        }
    }

    // Add a caption and a close button to the menu
    Rectangle {
        id: captionRectangle
        height: toolbar.height
        color: colors.darkGray
        anchors {left: parent.left; right: parent.right; top: parent.top;}

        Label {
            id: captionText
            height: device.ratio(48)
            color: colors.toolbarText
            font.pixelSize: sizes.large
            verticalAlignment: Text.AlignVCenter
            anchors {
                margins: 12;
                left: parent.left;
                verticalCenter: parent.verticalCenter;
            }
        }

        Image {
            width: height
            id: closeButton
            asynchronous: true
            height: device.ratio(48)
            opacity: opacity
            source: "qrc:/icons/ToolbarIcons/Common/Close.png"
            anchors {
                right: parent.right;
                margins: device.ratio(12);
                verticalCenter: parent.verticalCenter;
            }

            Behavior on opacity {NumberAnimation{}}

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    menu.anchors.topMargin = pageHeight
                }
            }
        }
    }
}
