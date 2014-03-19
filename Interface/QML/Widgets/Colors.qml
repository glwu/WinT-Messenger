//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2

QtObject {
    property string toolbarText: "#fff"
    property string background: "#f6f6f6"
    property string disabled: "#cbcbcb"
    property string borderColor: "#c7c7c7"

    property string text: "#000"

    property string logoTitle: "#222"
    property string logoSubtitle: "#444"

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
