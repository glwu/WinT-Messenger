//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

// IMPORTANT: DISABLE THE USE OF THIS PAGE UNTIL WE HAVE AT LEAST TWO RELIABLE CHAT SYSTEMS
//            LAN CHAT IS RELIABLE
//            BLUETOOTH CHAT WAS REMOVED DUE TO IMPLEMENTATION PROBLEMS
//            WIFI DIRECT CHAT WILL BE IMPLEMENTED ON THE NEAR FUTURE

import QtQuick 2.2
import "../controls" as Controls

Controls.Page {
    title: qsTr("Connect")
    toolbarTitle: qsTr("Connect")
    imageSource: "qrc:/icons/Connect.png"
    subtitle: qsTr("Please choose an option")

    Column {
        y: arrangeFirstItem
        spacing: device.ratio(4)
        anchors.horizontalCenter: parent.horizontalCenter

        Controls.Button {
            text: qsTr("LAN Chat")
            onClicked: {
                bridge.startLanChat()
                stackView.push("qrc:/qml/pages/chat.qml")
            }
        }
    }
}
