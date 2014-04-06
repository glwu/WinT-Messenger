//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Item {
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
        height                   : mobile ? 5 * titleText.height : 128
        width                    : height
    }

    Text {
        id                       : titleText
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.verticalCenter   : parent.verticalCenter
        color                    : colors.logoTitle
        font.pixelSize           : sizes.title
        font.family              : defaultFont
        horizontalAlignment      : Text.AlignHCenter
        verticalAlignment        : Text.AlignVCenter
    }

    Text {
        id                       : subtitleText
        anchors.horizontalCenter : parent.horizontalCenter
        color                    : colors.logoSubtitle
        font.pixelSize           : sizes.subtitle
        horizontalAlignment      : Text.AlignHCenter
        font.family              : defaultFont
        verticalAlignment        : Text.AlignVCenter
        wrapMode                 : Text.WrapAtWordBoundaryOrAnywhere
        y                        : titleText.y + titleText.height + 8
    }
}
