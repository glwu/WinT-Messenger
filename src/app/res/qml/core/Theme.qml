//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

QtObject {
    property string info: "#5bc0de"
    property string danger: "#f7846a"
    property string success: "#5cb85c"
    property string warning: "#ffc94e"
    property string darkGray : "#333"
    property string toolbarText: "#fff"
    property string highlight: "#008db6"
    property string disabled : "#c4d1d1"
    property string secondaryColor: "#888888"
    property string textFieldPlaceholder: "#aaaaaa"

    property string notificationText: "#000000"
    property string notificationBorder: "#f0c36e"
    property string notificationBackground: "#f9edbe"

    property string panel: "#FFFFFF"
    property string dialog: "#FFFFFF"
    property string shadow: "#666666"
    property string chatText: "#333333"
    property string iconColor: "#5A5E67"
    property string textColor: "#5A5E67"
    property string background: "#F8F8F8"
    property string borderColor: "#E6E6E6"
    property string logoSubtitle: "#4C505A"
    property string chatDateTimeText: "#415F9B"
    property string chatNotification: "#7F7F7F"
    property string textFieldBackground: "#FFFFFF"
    property string textFieldForeground: "#5A5E67"

    property string primary
    property string secondary
    property string navigationBar
    property string navigationBarText

    signal themeChanged()

    Component.onCompleted: setColors()

    function setColors() {
        primary = settings.customColor() ? settings.primaryColor() : "#666666"

        navigationBar = primary
        secondary = smartColor(primary)
        navigationBarText = calculateForeground(navigationBar)

        themeChanged()
    }

    function smartColor(input_color) {
        // Remove the "#" from hexadecimal color
        var color = input_color.replace("#", "")

        // Separate the hexadecimal values for Red, Green and Blue
        var r = color.substring(0, 2)
        var g = color.substring(2, 4)
        var b = color.substring(4, 6)

        // Convert hexadecimal numbers to decimals
        r = parseInt(r, 16)
        g = parseInt(g, 16)
        b = parseInt(b, 16)

        // Process the color using hardcoded values
        r = 2.65 * r
        g = 1.44 * g
        b = 1.24 * b

        // Remove any "extreme" colors and ensure that the
        // obtained colors are valid
        r = optimizeColor(r)
        g = optimizeColor(g)
        b = optimizeColor(b)

        // Convert the decimal values to hexadecimal values
        r = r.toString(16)
        g = g.toString(16)
        b = b.toString(16)

        // Get the final color
        return "#" + r + g + b
    }

    function optimizeColor(color) {
        // Ensure that we do not crash the program
        // if the color is 0
        if (color <= 0) {
            color = 16
        }

        // Ensure that the color is not too dark
        if (color < 24) {
            while (color < 24) {
                color = color * 2.4
            }
        }

        // Ensure that the color is not to bright
        if (color > 255) {
            while (color > 255) {
                color = color * 0.745
            }
        }

        // Round the obtained color to the nearest integer
        return Math.round(color)
    }

    function calculateForeground(color) {
        return "#FFF"
    }

    function getStyleColor(style) {
        if (style === "primary") return primary
        else if (style === "info") return info
        else if (style === "danger")  return danger
        else if (style === "success") return success
        else if (style === "warning") return warning
        else {
            console.log("Warning: " + style + " is not a valid style!")
            return textColor
        }
    }

    function getSelectedColor(lighter) {
        if (settings.customColor())
            return lighter ? Qt.lighter(primary, 1.5) : primary
        else
            return lighter ? info : primary
    }
}
