//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"
import QtQuick 2.3

ColumnPage {
    caption: title
    title: tr("Chat")
    iconName: "globe"
    subtitle: tr("Please select an option")

    signal chatHelpClicked
    signal localChatClicked
    signal onlineChatClicked

    contents: Column {
        spacing: units.scale(4)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -parent.height * 0.17

        Button {
            text: tr("Local chat")
            width: units.gu(24)
            onClicked: localChatClicked()
        }

        Button {
            text: tr("Online chat")
            width: units.gu(24)
            onClicked: onlineChatClicked()
        }

        Button {
            text: tr("Chat help")
            width: units.gu(24)
            onClicked: chatHelpClicked()
        }
    }
}
