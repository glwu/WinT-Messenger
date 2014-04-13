//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../Widgets"

Page {
    flickable: false
    logoEnabled: false
    toolbarTitle: qsTr("Chat room")

    Component.onCompleted: {
        enableAboutButton(false)
        enableSettingsButton(false)

        chatInterface.setText(qsTr("Welcome to the chat room!"), "gray")
    }

    onVisibleChanged: {
        enableAboutButton(!visible)
        enableSettingsButton(!visible)
    }

    ChatInterface {
        id: chatInterface
        anchors.topMargin: toolbar.height
    }
}
