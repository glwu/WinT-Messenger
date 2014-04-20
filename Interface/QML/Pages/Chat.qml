//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import "../Widgets"

Page {
    flickable: false
    logoEnabled: false
    toolbarTitle: Bridge.btChatEnabled() ? qsTr("Bluetooth chat") : qsTr("Network chat")

    Component.onCompleted: {
        toolbar.controlButtonsEnabled = false
        chatInterface.setText(Bridge.btChatEnabled() ?
                                  qsTr("Select a device to connect to by clicking the \"Bluetooth\" button") :
                                  qsTr("Welcome to the chat room!"),
                                  "gray")
    }

    onVisibleChanged: toolbar.controlButtonsEnabled = !visible

    ChatInterface {
        id: chatInterface
        anchors.topMargin: toolbar.height
    }
}
