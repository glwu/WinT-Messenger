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

import QtQuick 2.0

Dialog {
    id: _connect
    helpButton: true
    title: tr("Chat")

    signal localChatClicked
    signal onlineChatClicked

    contents: Item {
        id: item
        anchors.centerIn: parent

        Label {
            id: _caption
            text: tr("Chat")
            fontSize: "xx-large"
            color: theme.logoTitle
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -units.scale(12)
        }

        Label {
            id: _subtitle
            fontSize: "medium"
            color: theme.logoSubtitle
            anchors.top: _caption.bottom
            anchors.margins: units.scale(6)
            centered: true
            text: tr("Please select a chat method")
        }

        Image {
            id: _image
            width: height
            height: units.scale(96)
            anchors.bottom: _caption.top
            anchors.margins: units.scale(12)
            sourceSize: Qt.size(height, width)
            source: "qrc:/icons/icons/internet.svg"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            spacing: units.scale(4)

            anchors {
                top: _subtitle.bottom
                bottom: parent.bottom
                margins: units.scale(12)
                horizontalCenter: item.horizontalCenter
            }

            anchors.verticalCenterOffset: -parent.height * 0.17

            Button {
                text: tr("Local (LAN) chat")
                width: units.gu(24)
                onClicked: localChatClicked()
            }

            Button {
                text: tr("Online (XMPP) chat")
                width: units.gu(24)
                onClicked: {
                    _connect.close()
                    _xmppDialog.open()
                }
            }
        }
    }
}
