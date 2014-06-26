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

    //----- STYLE PROPERTIES -----//

    property color textColor: selected ? "white" : theme.secondaryColor
    property color background: theme.background
    height: units.gu(3.2)
    property int margins: units.gu(1)

    //


    anchors {
        left: parent.left
        right: parent.right
    }

    property int spacing

    color: background

    property bool selected: false

    property alias text: label.text
    property var fontSize: units.gu(2)
    //property alias iconColor: icon.color
    property alias font: label.font

    Label {
        id: label

        style: listItem.style
        color: textColor
        fontSize: listItem.fontSize

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            margins: margins
        }
    }

    property bool showDivider: true

    ThinDivider {
        anchors.bottom: parent.bottom
        visible: showDivider
    }
}
