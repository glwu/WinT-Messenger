//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import "../Widgets"

Page {
    toolbarTitle: qsTr("About")
    logoTitle: "WinT Messenger 1.1.3"
    logoImageSource: "qrc:/images/Info.png"
    logoSubtitle: qsTr("Created by the WinT 3794 team")

    onVisibleChanged: toolbar.controlButtonsEnabled = !visible
    Component.onCompleted: toolbar.controlButtonsEnabled = false

    Column {
        spacing: DeviceManager.ratio(4)
        y: arrangeFirstItem + 10 + parent.height / 16
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            text: qsTr("Website")
            onClicked: Qt.openUrlExternally("http://wint-im.sf.net")
        }

        Button {
            enabled: false
            text: qsTr("Donate")
            onClicked: Qt.openUrlExternally("http://wint-im.sf.net/donate.html")
        }
    }
}
