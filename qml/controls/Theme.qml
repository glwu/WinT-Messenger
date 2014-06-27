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
    property string userColor: settings.value("userColor", "#00557f")

    // This are the colors that vary depending if the user choosed to
    // use a dark interface or a light interface
    property string panel
    property string textColor
    property string logoTitle
    property string logoSubtitle
    property string background
    property string borderColor
    property string buttonBackground
    property string buttonForeground
    property string borderColorDisabled
    property string textFieldBackground
    property string textFieldForeground
    property string buttonBackgroundHover
    property string buttonBackgroundPressed
    property string buttonBackgroundDisabled
    property string buttonForegroundDisabled

    // Call the setColors() function when this object is created
    Component.onCompleted: setColors()

    // Set the colors depending on the theme (dark interface or light)
    function setColors() {
        panel                    = settings.darkInterface() ? "#383838" : "#ededed"
        textColor                = settings.darkInterface() ? "#aaaaaa" : "#666666"
        logoTitle                = settings.darkInterface() ? "#eeeeee" : "#333333"
        logoSubtitle             = settings.darkInterface() ? "#bebebe" : "#666666"
        background               = settings.darkInterface() ? "#4f4f4f" : "#ffffff"
        borderColor              = settings.darkInterface() ? "#323232" : "#bebebe"
        buttonForeground         = settings.darkInterface() ? "#dddddd" : "#222222"
        textFieldForeground      = settings.darkInterface() ? "#dddddd" : "#222222"
        buttonBackground         = settings.darkInterface() ? "#3f3f3f" : "#ebebeb"
        textFieldBackground      = settings.darkInterface() ? "#383838" : "#f7f7f7"
        buttonBackgroundPressed  = settings.darkInterface() ? "#222222" : "#e8e8e8"
        buttonBackgroundHover    = settings.darkInterface() ? "#333333" : "#f2f2f2"
        buttonBackgroundDisabled = settings.darkInterface() ? "#444444" : "#efefef"
        buttonForegroundDisabled = settings.darkInterface() ? "#888888" : "#838383"
        borderColorDisabled      = settings.darkInterface() ? "#292929" : "#d9d9d9"
    }

    // Return the a color based on the input string
    function getStyleColor(style) {
        if (style === "primary")
            return primary
        else if (style === "success")
            return success
        else if (style === "warning")
            return warning
        else if (style === "danger")
            return danger
        else if (style === "info")
            return info
        else
            return textColor
    }
}
