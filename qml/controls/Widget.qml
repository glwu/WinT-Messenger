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

Rectangle {
    id: widget

    property string style: "default"
    property bool mouseEnabled: opacity > 0
    visible: opacity > 0
    opacity: enabled ? 1 : 0.5

    Behavior on opacity {NumberAnimation {}}

    color: "transparent"

    signal clicked(var caller)
    signal doubleClicked(var caller)
    signal rightClicked(var caller)

    default property alias children: mouseArea.data

    property bool mouseOver: mouseEnabled ? mouseArea.containsMouse : false
    property alias pressed: mouseArea.pressed

    property alias mouseArea: mouseArea

    MouseArea {
        id: mouseArea
        enabled: mouseEnabled
        anchors.fill: parent
        hoverEnabled: !device.isMobile()
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        propagateComposedEvents: true

        onDoubleClicked: {
            if (mouse.button == Qt.LeftButton) {
                widget.forceActiveFocus()
                widget.doubleClicked(widget)
            }
        }

        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                widget.forceActiveFocus()
                widget.clicked(widget)
            }

            else if (mouse.button == Qt.RightButton) {
                widget.rightClicked(widget)
            }
        }
    }
}
