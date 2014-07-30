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

//-----------------------------------------------------------------------------//
// The \c widget allows us to implement controls in a simpler way. For example,//
// the \c widget is used in the Button.qml file and the Checkbox.qml
//-----------------------------------------------------------------------------//

Rectangle {
    id: widget

    // Create the properties of the widget, these are used to customize the
    // widget and/or get information related to its integrated mouse area.
    property string style: "default"
    property alias mouseArea: mouseArea
    property bool mouseEnabled: visible
    property alias pressed: mouseArea.pressed
    default property alias children: mouseArea.data
    property bool mouseOver: mouseEnabled ? mouseArea.containsMouse : false

    // This signal is emited when the mouseArea is clicked.
    // The slot is onClicked()
    signal clicked(var caller)

    // Disable the widget when its hidden
    visible: opacity > 0
    color: "transparent"

    // Make the widget semi transparent when its disabled
    opacity: enabled ? 1 : 0.5

    // Create the mouse area of the widget, this widget is used to perform
    // a certain task when the widget is pressed or get information related to
    // the widget state
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: mouseEnabled
        hoverEnabled: !device.isMobile()

        onClicked: {
            widget.clicked(widget)
            widget.forceActiveFocus()
        }
    }
}
