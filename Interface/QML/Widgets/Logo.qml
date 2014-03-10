//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0

Rectangle {
    property alias title    : titleText.text
    property alias subtitle : subtitleText.text
    property alias image    : image.source

    anchors.verticalCenter   : parent.verticalCenter
    anchors.horizontalCenter : parent.horizontalCenter

    Image {
        id                       : image
        anchors.bottom           : titleText.top
        anchors.bottomMargin     : 18
        anchors.horizontalCenter : parent.horizontalCenter
        height                   : 128
        width                    : 128
    }

    Text {
        id                       : titleText
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.verticalCenter   : parent.verticalCenter
        color                    : colors.logoTitle
        font.pixelSize           : smartFontSize(16)
        font.family              : defaultFont
        horizontalAlignment      : Text.AlignHCenter
        verticalAlignment        : Text.AlignVCenter
        antialiasing             : true
        smooth                   : true
    }

    Text {
        id                       : subtitleText
        anchors.horizontalCenter : parent.horizontalCenter
        color                    : colors.logoSubtitle
        font.pixelSize           : smartFontSize(12)
        horizontalAlignment      : Text.AlignHCenter
        font.family              : defaultFont
        smooth                   : true
        verticalAlignment        : Text.AlignVCenter
        wrapMode                 : Text.WrapAtWordBoundaryOrAnywhere
        y                        : titleText.y + titleText.height + 8
        antialiasing             : true
    }
}
