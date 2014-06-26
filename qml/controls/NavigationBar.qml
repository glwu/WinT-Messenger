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
import QtQuick 2.0

Widget {
    id: navbar

    // Create the properties of the navigation bar
    property int spacing: units.gu(1)
    property string title: currentPage.title
    property color background: theme.panel
    property color borderColor: theme.borderColor
    property alias leftWidgets: leftItem.children
    property alias rightWidgets: rightItem.children

    // These values are used to switch pages
    property Page currentPage
    property Page newPage

    function loadInitialPage(page) {
        currentPage = page
        titleWidget.anchors.horizontalCenterOffset = 0
        titleWidget.opacity = 1

        titleWidget2.opacity = 0
        titleWidget2.anchors.horizontalCenterOffset = units.gu(5)
    }

    function transitionToPage(page) {
        titleWidget2.text = page.title
        newPage = page
        pushAnimation.restart()
    }

    function transitionBackToPage(page) {
        titleWidget2.text = page.title
        newPage = page
        popAnimation.restart()
    }

    // Set the properties of the widget
    clip: true
    height: units.gu(6)

    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
    }

    // Create the background rectangle
    Rectangle {
        width: parent.width
        radius: navbar.radius
        color: navbar.background
        height: parent.height + navbar.radius
    }

    // Create the border
    Rectangle {
        height: 1
        color: theme.borderColor

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    // Create the label for the first page
    Label {
        id: titleWidget
        text: navbar.title
        fontSize: "x-large"
        anchors.centerIn: parent
    }

    // Create the label for the second page
    Label {
        opacity: 0
        id: titleWidget2
        text: navbar.title
        fontSize: "x-large"
        anchors.centerIn: parent
    }

    // Create the left widgets
    Row {
        id: leftItem
        anchors {
            left: parent.left
            leftMargin: units.gu(1)
            verticalCenter: parent.verticalCenter
        }

        spacing: units.gu(1)
        children: currentPage.leftWidgets
    }

    // Create the right widgets
    Row {
        id: rightItem
        anchors {
            right: parent.right
            rightMargin: units.gu(1)
            verticalCenter: parent.verticalCenter
        }

        spacing: units.gu(1)
        children: currentPage.rightWidgets
    }

    ParallelAnimation {
        id: pushAnimation

        NumberAnimation { target: titleWidget; property: "opacity"; to: 0; easing.type: Easing.InOutQuad }
        NumberAnimation { target: titleWidget.anchors; property: "horizontalCenterOffset"; duration: 400; from: 0; to: -units.gu(15); easing.type: Easing.InOutQuad }

        NumberAnimation { target: titleWidget2; property: "opacity"; from: 0; to: 1; easing.type: Easing.InOutQuad }
        NumberAnimation { target: titleWidget2.anchors; property: "horizontalCenterOffset"; duration: 400; from: units.gu(15); to: 0; easing.type: Easing.InOutQuad }

        SequentialAnimation {
            NumberAnimation {
                targets: [leftItem]; property: "opacity"; to: 0; easing.type: Easing.InOutQuad
            }

            ScriptAction {
                script: {
                    currentPage = newPage
                }
            }

            NumberAnimation {
                targets: [leftItem]; property: "opacity"; to: 1; easing.type: Easing.InOutQuad
            }

            ScriptAction {
                script: {
                    titleWidget.anchors.horizontalCenterOffset = 0
                    titleWidget.opacity = 1

                    titleWidget2.opacity = 0
                    titleWidget2.anchors.horizontalCenterOffset = units.gu(5)
                }
            }
        }
    }

    ParallelAnimation {
        id: popAnimation

        NumberAnimation { target: titleWidget; property: "opacity"; duration: 400; to: 0; easing.type: Easing.InOutQuad }
        NumberAnimation { target: titleWidget.anchors; property: "horizontalCenterOffset"; duration: 400; from: 0; to: units.gu(15); easing.type: Easing.InOutQuad }

        NumberAnimation { target: titleWidget2; property: "opacity"; duration: 400; from: 0; to: 1; easing.type: Easing.InOutQuad }
        NumberAnimation { target: titleWidget2.anchors; property: "horizontalCenterOffset"; duration: 400; from: -units.gu(15); to: 0; easing.type: Easing.InOutQuad }

        SequentialAnimation {
            NumberAnimation {
                targets: [leftItem]; property: "opacity"; to: 0; easing.type: Easing.InOutQuad
            }

            ScriptAction {
                script: {
                    currentPage = newPage
                }
            }

            NumberAnimation {
                targets: [leftItem]; property: "opacity"; to: 1; easing.type: Easing.InOutQuad
            }

            ScriptAction {
                script: {
                    titleWidget.anchors.horizontalCenterOffset = 0
                    titleWidget.opacity = 1

                    titleWidget2.opacity = 0
                    titleWidget2.anchors.horizontalCenterOffset = units.gu(5)
                }
            }
        }
    }
}
