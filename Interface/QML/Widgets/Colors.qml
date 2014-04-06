//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

QtObject {
    property string background: "#f7f7f7"
    property string disabled: "#cbcbcb"
    property string borderColor: "#c7c7c7"

    property string toolbarText: "#fff"
    property string toolbarColor: settings.customizedUiColor() ? userColor : "#333"
    property string toolbarColorStatic: "#333"
    property string toolbarPressedColor: "#666"

    property string text: "#000"

    property string logoTitle: toolbarColorStatic
    property string logoSubtitle: "#666"

    property string textFieldBackground: "#fdfdfd"
    property string textFieldForeground: "#222"
    property string textFieldPlaceholder: "#acacac"

    property string buttonBackground: "#ededed"
    property string buttonForeground: "#222222"
    property string userColor       : settings.value("userColor", "#00557f")

    property string buttonBackgroundHover: "#f2f2f2"
    property string borderColorHover     : borderColor

    property string buttonBackgroundPressed: "#e8e8e8"
    property string borderColorPressed     : borderColor

    property string buttonBackgroundDisabled: "#efefef"
    property string buttonForegroundDisabled: "#838383"
    property string borderColorDisabled     : "#d9d9d9"
}
