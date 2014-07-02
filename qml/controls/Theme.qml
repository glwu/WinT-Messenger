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

//--------------------------------------------------------------------//
// This object gives access to widgets to a common database of colors //
// that can be easilly changed to form a theme.                       //
// This approach allows the programmer to make a change only once and //
// it will be applied everywhere.                                     //
//--------------------------------------------------------------------//

QtObject {
    // These are the static colors
    property color primary: "#428bca"
    property color success: "#5cb85c"
    property color warning: "#f0ad4e"
    property color danger: "#d9534f"
    property color info: "#5bc0de"
    property string disabled : "#cbcbcb"
    property string darkGray : "#333"
    property string toolbarText: "#fff"
    property color secondaryColor: "#888"
    property string textFieldPlaceholder: "#aaa"
    property string userColor: settings.value("userColor", primary)

    // This are the colors that vary depending if the user choosed to
    // use a dark interface or a light interface
    property string panel
    property string textColor
    property string logoTitle
    property string background
    property string borderColor
    property string logoSubtitle
    property string navigationBar
    property string buttonBackground
    property string buttonForeground
    property string navigationBarText
    property string borderColorDisabled
    property string textFieldBackground
    property string textFieldForeground
    property string buttonBackgroundHover
    property string buttonBackgroundPressed
    property string buttonBackgroundDisabled
    property string buttonForegroundDisabled

    // Call the setColors() function when this object is created
    Component.onCompleted: setColors()

    // Allow other widgets to redraw themselves
    signal themeChanged()

    // Set the colors depending on the theme (dark interface or light)
    function setColors() {
        // Change the colors based on the theme setting (dark theme or light theme)
        panel                    = settings.darkInterface() ? "#383838" : "#ededed"
        textColor                = settings.darkInterface() ? "#aaaaaa" : "#666666"
        logoTitle                = settings.darkInterface() ? "#eeeeee" : "#333333"
        logoSubtitle             = settings.darkInterface() ? "#bebebe" : "#666666"
        background               = settings.darkInterface() ? "#4f4f4f" : "#ffffff"
        borderColor              = settings.darkInterface() ? "#323232" : "#bebebe"
        buttonForeground         = settings.darkInterface() ? "#dddddd" : "#222222"
        textFieldForeground      = settings.darkInterface() ? "#dddddd" : "#222222"
        buttonBackground         = settings.darkInterface() ? "#3f3f3f" : "#ededed"
        textFieldBackground      = settings.darkInterface() ? "#383838" : "#f7f7f7"
        buttonBackgroundPressed  = settings.darkInterface() ? "#222222" : "#e8e8e8"
        buttonBackgroundHover    = settings.darkInterface() ? "#333333" : "#f2f2f2"
        buttonBackgroundDisabled = settings.darkInterface() ? "#444444" : "#efefef"
        buttonForegroundDisabled = settings.darkInterface() ? "#888888" : "#838383"
        borderColorDisabled      = settings.darkInterface() ? "#292929" : "#d9d9d9"

        // These values are dependend on other colors, so we set them at the end
        navigationBar            = settings.customColor()   ? userColor : panel
        navigationBarText        = settings.customColor()   ? "#ffffff" : textColor

        // Alert all widgets that the theme has changed
        themeChanged()
    }

    // Return the a color based on the input string
    function getStyleColor(style) {

        // Return a different color based on the
        // current theme colors.
        if (style === "primary") {
            if (settings.customColor())
                return userColor
            else
                return primary
        }

        // Return a greenish color
        else if (style === "success")
            return success

        // Return an orange-ish color
        else if (style === "warning")
            return warning

        // Return a redish color
        else if (style === "danger")
            return danger

        // Return a bluish color
        else if (style === "info")
            return info

        // Return the value of textColor
        else
            return textColor
    }

    // Based on the current settings, return a color for highlighted
    // wisgets.
    function getSelectedColor(lighter) {

        // Return a lighter color in the navigation bar buttons, and
        // return the normal \c userColor on normal widgets, such as
        // checkboxes and buttons
        if (settings.customColor()) {
            if (lighter)
                return Qt.lighter(userColor, 1.5)
            else
                return userColor
        }

        // Return the pre-fabricated colors if the user's settings
        // are set to use the default theme colors.
        else {
            if (lighter)
                return info
            else
                return primary
        }
    }
}
