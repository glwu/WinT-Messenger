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
import QtQuick.Window 2.0
import QtQuick.Controls 1.1

//----------------------------------------------------------------------------//
// This file creates a window with the default variables used accross the app //
//----------------------------------------------------------------------------//

Window {
    id: app

    // Load the common properties used across the app, such as the theme and the
    // current overlay (used in sheet dialogs).
    property Theme theme: Theme {}
    property alias overlayLayer: overlay
    property PopupBase currentOverlay: null
    default property alias data: contents.data
    property bool overlayOpen: currentOverlay !== null

    // This object is used to get the family of the loaded font. This makes the
    // process of changing the default font more easy because we don't need to
    // define the name of the font all over again. The only necessary step would be
    // to replace the regular.ttf file with your desired font.
    property var global: QtObject {

        // Load the Lato font
        property var loader: FontLoader {
            source: "qrc:/fonts/regular.ttf"
        }

        // Return the name of the loader font
        property string font: loader.name
    }

    // This object is used to automatically resize UI elements
    property var units: QtObject {

        // Return the input value multiplied by 8 (scaled) pixels
        function gu(units) {
            return units * device.ratio(8);
        }

        // Return a value based on a string
        function fontSize(size) {
            // Return a value of 21.6 pixels
            if (size === "xx-large")
                return gu(2.7)

            // Return a value of 19.2 pixels
            else if (size === "x-large")
                return gu(2.4)

            // Return a value of 17.6 pixels
            else if (size === "large")
                return gu(2.2)

            // Return a value of 15.2 pixels
            else if (size === "medium")
                return gu(1.9)

            // Return a value of 12.8 pixels
            else if (size === "small")
                return gu(1.6)

            // Return the same value as a medium widget
            else
                return gu(1.9)
        }
    }

    // Load the contents of the application
    Rectangle {
        id: contents
        anchors.fill: parent
    }

    // This rectangle is used to show sheet dialogs
    Rectangle {
        anchors.fill: parent

        // Set the visibility of the overlay based if there is a visible sheet
        // to clarify all the shit here, the overlay a semi-transparent black rectangle
        // that covers all the application when the dialog is visible.
        color: currentOverlay !== null ? currentOverlay.overlayColor : "transparent"
        opacity: overlayOpen ? 1 : 0
        visible: opacity > 0

        // Fade the overlay when opening or closing a dialog
        Behavior on opacity {NumberAnimation {}}
    }

     // This item is used to show sheet dialogs
    Item {
        id: overlay
        anchors.fill: parent
    }
}
