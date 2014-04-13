//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import "../Widgets"

Page {
    backButtonEnabled: false
    logoImageSource: "qrc:/images/Logo.png"
    logoSubtitle: qsTr("Please choose an option")
    logoTitle: qsTr("Welcome")
    toolbarTitle: qsTr("Start")

    Column {
        spacing: DeviceManager.ratio(4)
        y: arrangeFirstItem + parent.height / 32
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            onClicked: openPage("Pages/Connect.qml")
            text: qsTr("Connect")
        }

        Button {
            onClicked: Qt.openUrlExternally("http://wint-im.sf.net/news.html")
            text: qsTr("News")
        }

        Button {
            onClicked: openPage("Pages/Help/Help.qml")
            text: qsTr("Help")
        }
    }
}
