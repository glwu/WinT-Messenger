//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../Widgets"

Page {
    logoImageSource : "qrc:/images/Connect.png"
    logoTitle       : qsTr("Connect")
    toolbarTitle    : qsTr("Connect")
    logoSubtitle    : qsTr("Please select a communication method")

    property int perfectY: arrangeFirstItem + parent.height / 32

    Column {
        spacing: 8
        y: perfectY
        anchors.horizontalCenter : parent.horizontalCenter

        Button {
            onClicked : openPage("Pages/BtChat.qml")
            text      : qsTr("Bluetooth")
            enabled   : false
        }

        Button {
            onClicked : openPage("Pages/AdHocChat.qml")
            text      : qsTr("Ad-hoc network")
            enabled   : false
        }

        Button {
            text      : qsTr("Local Network")
            onClicked : {
                text = qsTr("Please wait...")
                enabled = false

                bridge.startLanChat()
                openPage("Pages/LanChat.qml")

                text = qsTr("Local Network")
                enabled = true
            }
        }
    }


}
