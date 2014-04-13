//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../Widgets"

Page {
    logoImageSource: "qrc:/images/Connect.png"
    logoTitle: qsTr("Connect")
    toolbarTitle: qsTr("Connect")
    logoSubtitle: qsTr("Please select a communication method")

    Column {
        spacing: DeviceManager.ratio(4)
        y: arrangeFirstItem + parent.height / 32
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            onClicked: openPage("Pages/Chat.qml")
            text: qsTr("Bluetooth")
            enabled: false
        }

        Button {
            onClicked: openPage("Pages/Hotspot/Wizard.qml")
            text: qsTr("Setup a wireless hotspot")
        }

        Button {
            text: qsTr("Local Network")
            onClicked: {
                text = qsTr("Please wait...")
                enabled = false

                Bridge.startNetChat()
                openPage("Pages/Chat.qml")

                text = qsTr("Local Network")
                enabled = true
            }
        }
    }


}
