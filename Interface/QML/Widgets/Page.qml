//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2

Item {
    id: page

    property bool backButtonEnabled    : true
    property bool logoEnabled          : true
    property string logoImageSource    : ""
    property string logoSubtitle       : qsTr("Subtitle goes here")
    property string logoTitle          : qsTr("Title goes here")
    property string toolbarTitle       : qsTr("Title")
    property int arrangeFirstItem      : logoEnabled ? 1.12 * (logo.y + logo.height + 12) : toolbar.height + 12
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
