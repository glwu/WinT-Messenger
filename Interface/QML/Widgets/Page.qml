//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Flickable {
    id: page

    property bool backButtonEnabled    : true
    property bool flickable            : true
    property bool logoEnabled          : true
    property string logoImageSource    : ""
    property string logoSubtitle       : qsTr("Subtitle goes here")
    property string logoTitle          : qsTr("Title goes here")
    property string toolbarTitle       : qsTr("Title")
    property int arrangeFirstItem      : logoEnabled ? 1.125 * (logo.y + logo.height + bridge.ratio(12)) : toolbar.height + bridge.ratio(4)

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

    contentHeight        : rootWindow.height
    interactive          : flickable
    flickableDirection   : Flickable.VerticalFlick

    Logo {
        id: logo
        enabled  : page.logoEnabled
        image    : page.logoImageSource
        subtitle : page.logoSubtitle
        title    : page.logoTitle
        visible  : page.logoEnabled
    }

    MouseArea {
        id: swipeDetector
        anchors.fill: parent

        property int oldX: 0
        property int oldY: 0

        hoverEnabled: false
        visible: true

        onPressed: {
            oldX = mouseX;
            oldY = mouseY;
        }

        onReleased: {
            var xDiff = oldX - mouseX;
            var yDiff = oldY - mouseY;

            if(Math.abs(xDiff) > Math.abs(yDiff))
                if(oldX < mouseX)
                    stackView.pop()
        }
    }
}
