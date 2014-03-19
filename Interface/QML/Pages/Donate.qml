//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../Widgets"

Page {
    logoImageSource : "qrc:/images/Donate.png"
    logoSubtitle    : qsTr("Support the development of this app")
    logoTitle       : qsTr("Donate")
    toolbarTitle    : qsTr("Donate")

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
            text                : qsTr("Sorry, this feature is not implemented yet")
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
            text                : qsTr("We will implement it later")
            font.family         : defaultFont
            anchors.left        : parent.left
            anchors.right       : parent.right
            horizontalAlignment : Text.AlignHCenter
        }

    }

    Button {
        id: moreInfoButton
        anchors.bottom           : parent.bottom
        anchors.bottomMargin     : perfectY
        anchors.horizontalCenter : parent.horizontalCenter
        text                     : qsTr("Donate")
        onClicked                : Qt.openUrlExternally("http://wint3794.org/donate")
        enabled                  : false
    }
}
