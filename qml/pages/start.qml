//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import "../controls" as Controls

Controls.Page {
    title: qsTr("Welcome")
    toolbarTitle: qsTr("Welcome")
    imageSource: "qrc:/icons/Logo.svg"
    subtitle: qsTr("Please choose an option")

    Column {
        y: arrangeFirstItem
        spacing: device.ratio(4)
        anchors.horizontalCenter: parent.horizontalCenter

        Controls.Button {
            text: qsTr("Chat")
            onClicked: {
                bridge.startChat()
                stackView.push("qrc:/qml/pages/chat.qml")
            }
        }

        Controls.Button {
            text: qsTr("News")
            onClicked: Qt.openUrlExternally("http://wint-im.sf.net/#news")
        }

        Controls.Button {
            text: qsTr("Help")
            onClicked: stackView.push("qrc:/qml/pages/help.qml")
        }
    }
}
