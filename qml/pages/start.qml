//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import "../controls" as Controls

Controls.Page {
    // Configure the title tof the toolbar and the appearance of the logo.
    title: qsTr("Welcome")
    toolbarTitle: qsTr("Welcome")
    imageSource: "qrc:/icons/Logo.svg"
    subtitle: qsTr("Please choose an option")

    // This column shows some option buttons centered to the
    // parent's horizontal center.
    Column {
        y: arrangeFirstItem
        spacing: device.ratio(4)
        anchors.horizontalCenter: parent.horizontalCenter

        // This button is used to open the Chat page
        // to join a LAN chat room.
        Controls.Button {
            text: qsTr("Chat")
            onClicked: {
                bridge.startChat()
                stackView.push("qrc:/qml/pages/chat.qml")
            }
        }

        // This button is used to open the News web page
        // in a web browser.
        Controls.Button {
            text: qsTr("News")
            onClicked: Qt.openUrlExternally("http://wint-im.sf.net/#news")
        }

        // This button is used to open the Help page, where users can open
        // many useful links in their web browser.
        Controls.Button {
            text: qsTr("Help")
            onClicked: stackView.push("qrc:/qml/pages/help.qml")
        }
    }
}
