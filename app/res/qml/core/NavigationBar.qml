//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../controls"

import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    height: units.gu(6)

    // The property represents the current page,
    // it is used to display the page's left and
    // right widgets
    property Page currentPage

    // This property is used to change the title
    // of the navigation bar
    property alias title: _title.text

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    // Add a shadow to the navigation bar to give it
    // more depth.
    RectangularGlow {
        opacity: 0.5
        color: theme.shadow
        anchors.fill: _panel
        glowRadius: units.scale(6)
    }

    // This rectangle is used to draw the background
    // of the navigation bar
    Rectangle {
        id: _panel
        anchors.fill: parent
        color: theme.navigationBar

        // Create the bottom border line
        Rectangle {
            id: _border
            height: units.scale(1)
            color: Qt.darker(parent.color, 1.1)

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
        }
    }

    // Create the left item widgets
    Row {
        id: leftItem
        spacing: units.gu(1)
        children: currentPage.leftWidgets

        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
    }

    // Create the right item widgets
    Row {
        id: rightItem
        spacing: units.gu(2)
        layoutDirection: Qt.RightToLeft
        children: currentPage.rightWidgets

        anchors {
            right: parent.right
            rightMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
    }

    // This label is used to display the title
    // of the navigation bar
    Label {
        id: _title
        fontSize: "x-large"
        maximumLineCount: 1
        elide: Text.ElideRight
        textFormat: Text.PlainText
        color: theme.navigationBarText
        horizontalAlignment: Text.AlignHCenter

        // Calculate the required left margin to center
        // the label
        property int leftMargin: {
            if (rightItem.width > leftItem.width)
                return rightItem.width - units.gu(1)
            else
                return units.gu(1)
        }

        // Calculate the required right matgin to center
        // the label
        property int rightMargin: {
            if (rightItem.width < leftItem.width)
                return leftItem.width - units.gu(1)
            else
                return units.gu(1)
        }

        // Anchor the title label
        anchors {
            left: leftItem.right
            right: rightItem.left
            leftMargin: _title.leftMargin
            rightMargin: _title.rightMargin
            verticalCenter: parent.verticalCenter
        }
    }
}
