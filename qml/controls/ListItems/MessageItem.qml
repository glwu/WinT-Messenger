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
import ".."

Widget {
    id: listItem
    anchors {
        left: parent.left
        right: parent.right
    }

    color: selected ? theme.primary
                    : mouseOver ? theme.buttonBackgroundHover : "transparent"

    property color foregroundColor: listItem.selected ? "white" : theme.textColor

    height: Math.max(column.height + units.gu(1), units.gu(6))

    property bool selected: false

    property string iconName: ""
    property alias title: label.text
    property string subject
    property string date
    property int fontSize: units.gu(2)
    property alias iconColor: icon.color
    property alias font: label.font

    Icon {
        id: icon

        name: iconName
        size: units.gu(3)
        color: foregroundColor

        width: height

        anchors {
            left: parent.left
            leftMargin: units.gu(1.2)
            verticalCenter: parent.verticalCenter
        }
    }

    Column {
        id: column
        anchors {
            verticalCenter: parent.verticalCenter
            left: iconName === "" ? parent.left : icon.right
            right: parent.right
            margins: units.gu(1.2)
        }

        Item {
            width: parent.width
            height: label.height
            Label {
                id: label

                color: foregroundColor
                font.bold: true
                elide: Text.ElideRight
                anchors {
                    left: parent.left
                    right: dateLabel.right
                    rightMargin: units.gu(1.2)
                    verticalCenter: parent.verticalCenter
                }
            }

            Label {
                id: dateLabel

                color: foregroundColor
                text: date
                font.italic: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }
        }

        Label {
            id: subjectLabel

            color: foregroundColor
            text: subject
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            maximumLineCount:2
        }
    }

    property bool showDivider: true

    Rectangle {
        anchors.bottom: parent.bottom
        height: device.ratio(1)
        width: parent.width
        visible: showDivider
        color: theme.borderColor
    }
}
