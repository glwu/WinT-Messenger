//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0
import "../../Widgets"

Page {
    logoImageSource : "qrc:/images/Doc/GNU.png"
    logoSubtitle    : qsTr("Learn more about the GPL")
    logoTitle       : qsTr("About the GPL")
    toolbarTitle    : qsTr("About GPL")

    property int perfectY: 10 + parent.height / 16

    Column {
        anchors.left        : parent.left
        anchors.right       : parent.right
        anchors.leftMargin  : 16
        anchors.rightMargin : 16
        spacing             : 12
        y                   : [(moreInfoButton.y + (arrangeFirstItem - 92)) / 2] - 8

        Text {
            id: infoLabel
            color               : colors.logoTitle
            font.pixelSize      : smartFontSize(11)
            wrapMode            : Text.WrapAtWordBoundaryOrAnywhere
            text                : qsTr("The GNU General Public License is the most widely used free software license, it guarantees end users the freedoms to use, study, share, and modify the software.")
            font.family         : defaultFont
            anchors.left        : parent.left
            anchors.right       : parent.right
            horizontalAlignment : Text.AlignHCenter
        }

        Text {
            id: moreInfoLabel
            color               : colors.logoSubtitle
            font.pixelSize      : smartFontSize(10)
            wrapMode            : Text.WrapAtWordBoundaryOrAnywhere
            text                : qsTr("This program is released under the General Public License 3.0.")
            font.family         : defaultFont
            anchors.left        : parent.left
            anchors.right       : parent.right
            horizontalAlignment : Text.AlignHCenter
            visible             : !isMobile
        }

    }

    Button {
        id: moreInfoButton
        anchors.bottom           : parent.bottom
        anchors.bottomMargin     : perfectY
        anchors.horizontalCenter : parent.horizontalCenter
        text                     : qsTr("More information")
        onClicked                : Qt.openUrlExternally("http://en.wikipedia.org/wiki/GPL_3#Version_3")
    }
}
