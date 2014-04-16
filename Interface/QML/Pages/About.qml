//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import "../Widgets"

Page {
    logoImageSource: "qrc:/images/Info.png"
    logoSubtitle: qsTr("Created by the WinT 3794 team")
    logoTitle: qsTr("WinT Messenger 1.1.2")
    toolbarTitle: qsTr("About")

    Component.onCompleted: {
        toolbar.aboutButtonEnabled = false
        toolbar.settingsButtonEnabled = false
   }

    onVisibleChanged: {
        toolbar.aboutButtonEnabled = !visible
        toolbar.settingsButtonEnabled = !visible
   }

    Column {
        y: arrangeFirstItem + 10 + parent.height / 16
        spacing: DeviceManager.ratio(4)
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            text: qsTr("Website")
            onClicked: Qt.openUrlExternally("http://wint-im.sf.net")
       }

        Button {
            onClicked: Qt.openUrlExternally("http://wint-im.sf.net/donate.html")
            text: qsTr("Donate")
            enabled: false
       }
   }
}
