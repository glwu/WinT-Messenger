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
import QtQuick.Window 2.0

Window {
    id: app

    // Load the common properties used across the app
    property Theme theme: Theme {}
    property alias overlayLayer: overlay
    property PopupBase currentOverlay: null
    default property alias data: contents.data
    property bool overlayOpen: currentOverlay !== null

    // This object is used to get the loaded font
    property var global: QtObject {
        property string font: "Lato"
    }

    // This object is used to automatically resize UI elements
    property var units: QtObject {
        function gu(units) {
            return units * device.ratio(8);
        }

        function fontSize(size) {
            if (size === "xx-large")
                return gu(2.7)
            else if (size === "x-large")
                return gu(2.4)
            else if (size === "large")
                return gu(2.2)
            else if (size === "medium")
                return gu(1.9)
            else if (size === "small")
                return gu(1.6)
            else
                return Number(size)
        }
    }

    // Load the Lato font
    FontLoader {
        source: "qrc:/fonts/regular.ttf"
    }

    // Load the contents here
    Rectangle {
        id: contents
        anchors.fill: parent
    }

    // This rectangle is used to show sheet dialogs
    Rectangle {
        anchors.fill: parent

        color: currentOverlay !== null ? currentOverlay.overlayColor : "transparent"
        opacity: overlayOpen ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {NumberAnimation {}}
    }

     // This item is used to show sheet dialogs
    Item {
        id: overlay
        anchors.fill: parent
    }
}
