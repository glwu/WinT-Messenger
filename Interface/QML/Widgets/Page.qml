//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0

Rectangle {
    id: page

    color: "transparent"

    property bool backButtonEnabled    : true
    property bool logoEnabled          : true
    property string logoImageSource    : ""
    property string logoSubtitle       : qsTr("Subtitle goes here")
    property string logoTitle          : qsTr("Title goes here")
    property string toolbarTitle       : qsTr("Title")
    property int arrangeFirstItem      : logoEnabled ? page.height - [(page.height - 128) / 2] + 3 : smartBorderSize(64)
    property bool resizeGripEnabled    : isMobile ? false : true

    signal setupPage(string _toolbarTitle, bool _backButtonEnabled)
    onSetupPage: {
        setBackButtonEnabled(_backButtonEnabled)
        setTitle(_toolbarTitle)
    }

    Component.onCompleted: setupPage(toolbarTitle, backButtonEnabled)
    onVisibleChanged: {
        if (visible)
            setupPage(toolbarTitle, backButtonEnabled)
    }

    Logo {
        id: logo
        enabled  : page.logoEnabled
        image    : page.logoImageSource
        subtitle : page.logoSubtitle
        title    : page.logoTitle
        visible  : page.logoEnabled
    }
}
