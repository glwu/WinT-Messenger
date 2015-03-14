//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"
import QtQuick 2.0

ColumnPage {
    caption: title
    title: qsTr("Chat")
    iconName: "globe"
    subtitle: qsTr("Please select an option")

    signal chatHelpClicked
    signal localChatClicked
    signal onlineChatClicked

    contents: Column {
        spacing: units.scale(4)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -parent.height * 0.17

        Button {
            text: qsTr("Local chat (LAN)")
            width: units.gu(24)
            onClicked: localChatClicked()
        }

        Button {
            text: qsTr("Online chat (XMPP)")
            width: units.gu(24)
            onClicked: onlineChatClicked()
        }

        Button {
            text: qsTr("Learn more")
            width: units.gu(24)
            onClicked: chatHelpClicked()
        }
    }
}
