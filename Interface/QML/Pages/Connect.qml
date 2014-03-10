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

    Label {
        anchors.horizontalCenter : parent.horizontalCenter
        y                        : perfectY - height - 21
        text                     : qsTr("If you are on a FIRST event, <a href='http://www.wint3794.org'>read the FIRST Notice</a>.")
        onLinkActivated          : openPage("Pages/Help/Notice.qml")
        textFormat               : Qt.RichText
    }

    Column {
        spacing: 8
        y: perfectY + parent.height / 32
        anchors.horizontalCenter : parent.horizontalCenter

        Button {
            anchors.horizontalCenter : parent.horizontalCenter
            onClicked : openPage("Pages/BtChat.qml")
            text      : qsTr("Bluetooth")
            enabled   : false
        }

        Button {
            anchors.horizontalCenter : parent.horizontalCenter
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
