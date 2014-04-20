//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import "../../Widgets"

Page {
    logoTitle: qsTr("Help")
    toolbarTitle: qsTr("Help")
    logoImageSource: "qrc:/images/Help.png"
    logoSubtitle: qsTr("Learn the basics of this app")

    Column {
        spacing: DeviceManager.ratio(4)
        y: arrangeFirstItem + parent.height / 32
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            text: qsTr("Help")
            onClicked: openPage("qrc:/QML/Pages/Help/Documentation.qml")
        }

        Button {
            text: qsTr("About Qt")
            onClicked: Qt.openUrlExternally("http://en.wikipedia.org/wiki/Qt_(software)")
        }

        Button {
            text: qsTr("About the GPL 3.0")
            onClicked: Qt.openUrlExternally("https://www.gnu.org/copyleft/gpl.html")
        }
    }
}
