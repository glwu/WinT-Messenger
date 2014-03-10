//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0
import "../../Widgets"

Page {
    logoImageSource : "qrc:/images/Doc/Qt.png"
    logoSubtitle    : qsTr("Learn more about the Qt framework")
    logoTitle       : qsTr("About Qt")
    toolbarTitle    : qsTr("About Qt")

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
            text                : qsTr("Qt is a cross-platform application and UI framework for developers using C++ and/or QML")
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
            text                : qsTr("This application is based on Qt 5.2")
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
        text                     : qsTr("More information")
        onClicked                : Qt.openUrlExternally("http://qt-project.org")
    }
}
