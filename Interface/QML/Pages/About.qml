//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../Widgets"

Page {
    logoImageSource : "qrc:/images/Logo.png"
    logoSubtitle    : qsTr("Created by the WinT 3794 team")
    logoTitle       : qsTr("WinT Messenger 1.1")
    toolbarTitle    : qsTr("About")

    property int perfectY: 10 + parent.height / 16

    Component.onCompleted: {
        enableAboutButton(false)
        enableSettingsButton(false)
    }

    onVisibleChanged: {
        enableAboutButton(!visible)
        enableSettingsButton(!visible)
    }

    Column {
        y                        : arrangeFirstItem + perfectY
        spacing                  : smartSize(4)
        anchors.horizontalCenter : parent.horizontalCenter

        Button {
            text      : qsTr("Website")
            onClicked : Qt.openUrlExternally("http://wint-im.sf.net")
        }
    }
}
