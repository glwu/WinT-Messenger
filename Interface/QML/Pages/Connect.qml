//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import "../Widgets"

Page {
    logoTitle: qsTr("Connect")
    toolbarTitle: qsTr("Connect")
    logoImageSource: "qrc:/images/Connect.png"
    logoSubtitle: qsTr("Please select a communication method")

    Column {
        spacing: DeviceManager.ratio(4)
        y: arrangeFirstItem + parent.height / 32
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            text: qsTr("Bluetooth chat")
            enabled: !DeviceManager.isMobile()
            onClicked: {
                Bridge.startBtChat()
                openPage("qrc:/QML/Pages/Chat.qml")
            }
        }

        Button {
            text: qsTr("Network (LAN) chat")
            onClicked: {
                Bridge.startNetChat()
                openPage("qrc:/QML/Pages/Chat.qml")
            }
        }

        Button {
            text: qsTr("Setup a wireless hotspot")
            onClicked: openPage("qrc:/QML/Pages/Hotspot/Wizard.qml")
        }
    }
}
