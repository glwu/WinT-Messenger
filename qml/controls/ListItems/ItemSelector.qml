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

BaseListItem {
    id: dropDown
    objectName: "optionSelector"

    width: units.gu(20)
    z: 1

    property int cellHeight: units.gu(4)

    property bool opened

    property alias count: repeater.count
    property alias model: repeater.model
    property int selectedIndex: 0

    property alias delegate: repeater.delegate

    height: opened ? column.height : dropDown.cellHeight
    clip: true

    Behavior on height {
        NumberAnimation {}
    }

    Column {
        id: column
        anchors {
            left: parent.left
            right: parent.right
            margins: 1
        }

        y: opened ? 0 : -selectedIndex * dropDown.cellHeight

        Behavior on y {
            NumberAnimation {}
        }

        Repeater {
            id: repeater
        }
    }

    mouseEnabled: !opened
    onClicked: opened = true
}
