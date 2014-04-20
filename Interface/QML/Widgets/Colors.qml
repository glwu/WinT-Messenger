//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

QtObject {
    property string disabled : "#cbcbcb"
    property string toolbarText : "#fff"
    property string toolbarColorStatic : "#333"
    property string textFieldPlaceholder: "#aaa"
    property string userColor: Settings.value("userColor", "#0081bd")
    property string toolbarColor: Settings.customizedUiColor() ? userColor : "#333"

    property string text
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

    Component.onCompleted: setColors()

    function setColors() {
        text = Settings.darkInterface() ? "#eee" : "#000"
        logoTitle = Settings.darkInterface() ? "#fff" : "#333"
        logoSubtitle = Settings.darkInterface() ? "#ddd" : "#666"
        background = Settings.darkInterface() ? "#444" : "#f7f7f7"
        borderColor = Settings.darkInterface() ? "#555" : "#c7c7c7"
        buttonForeground = Settings.darkInterface() ? "#ddd" : "#222"
        textFieldForeground = Settings.darkInterface() ? "#ddd" : "#222"
        buttonBackground = Settings.darkInterface() ? "#333" : "#ededed"
        textFieldBackground = Settings.darkInterface() ? "#333" : "#fdfdfd"
        buttonBackgroundPressed = Settings.darkInterface() ? "#222" : "#e8e8e8"
        buttonBackgroundHover = Settings.darkInterface() ? "#3a3a3a" : "#f2f2f2"
        buttonBackgroundDisabled = Settings.darkInterface() ? "#444" : "#efefef"
        buttonForegroundDisabled = Settings.darkInterface() ? "#888" : "#838383"
        borderColorDisabled = Settings.darkInterface() ? borderColor : "#d9d9d9"
    }
}
