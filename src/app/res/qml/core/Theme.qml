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
    property string danger: "#d9534f"
    property string success: "#5cb85c"
    property string warning: "#f0ad4e"
    property string darkGray : "#333"
    property string toolbarText: "#fff"
    property string highlight: "#008db6"
    property string disabled : "#cbcbcb"
    property string secondaryColor: "#888"
    property string textFieldPlaceholder: "#aaa"

    property string notificationText: "#000"
    property string notificationBorder: "#f0c36e"
    property string notificationBackground: "#f9edbe"

    property string panel
    property string dialog
    property string shadow
    property string primary
    property string chatText
    property string textColor
    property string logoTitle
    property string iconColor
    property string background
    property string borderColor
    property string logoSubtitle
    property string navigationBar
    property string chatDateTimeText
    property string chatNotification
    property string navigationBarText
    property string textFieldBackground
    property string textFieldForeground

    signal themeChanged()

    Component.onCompleted: setColors()

    function setColors() {
        panel                    = settings.darkInterface() ? "#383838" : "#f2f2f2"
        dialog                   = settings.darkInterface() ? "#444444" : "#fffffd"
        shadow                   = settings.darkInterface() ? "#000000" : "#666666"
        chatText                 = settings.darkInterface() ? "#efefef" : "#333333"
        textColor                = settings.darkInterface() ? "#adadad" : "#666666"
        logoTitle                = settings.darkInterface() ? "#f6f6f6" : "#232323"
        logoSubtitle             = settings.darkInterface() ? "#a4a4a4" : "#666666"
        background               = settings.darkInterface() ? "#333333" : "#eeeeee"
        textFieldForeground      = settings.darkInterface() ? "#dddddd" : "#222222"
        chatDateTimeText         = settings.darkInterface() ? "#5bc0de" : "#415f9b"
        chatNotification         = settings.darkInterface() ? "#b3b3b3" : "#7f7f7f"
        textFieldBackground      = settings.darkInterface() ? "#383838" : "#f7f7f7"
        borderColor              = settings.darkInterface() ? "#333333" : "#d3d3d3"

        iconColor = settings.darkInterface() ? primary : textColor
        primary = settings.customColor() ? settings.primaryColor() : settings.darkInterface() ? "#383838" : "#666"

        navigationBar = primary
        navigationBarText = "#fff"

        themeChanged()
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
