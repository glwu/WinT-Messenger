//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"

import QtQuick 2.0
import QtQuick.Controls 1.0 as Controls

Page {
    id: page
    interactive: false

    property bool sound_enabled: settings.soundsEnabled()

    function setTitle(string) {
        title = string
        navigationBar.title = string
    }

    function addUser(nickname, id) {
        if (sound_enabled) {
            soundTimer.start()
            sound_enabled = false
            bridge.playSound("login")
        }

        notification.show(tr("%1 has joined the room").arg(nickname), "users")
    }

    function removeUser(nickname) {
        if (sound_enabled) {
            soundTimer.start()
            sound_enabled = false
            bridge.playSound("logout")
        }

        notification.show(tr("%1 has left the room").arg(nickname), "users")
    }

    Connections {
        target: bridge
        onDelUser: removeUser(nick)
        onNewUser: addUser(nick, id)
    }

    onVisibleChanged: {
        if (!visible) {
            bridge.stopXmpp()
            bridge.stopLanChat()

            _sidebar.clear()
            _messageStack.clear()
            _sidebar.autoAdjustWidth()
        }
    }


    Rectangle {
        color: theme.dialog
        anchors.fill: parent
    }

    Timer {
        id: soundTimer
        interval: 750
        onTriggered: sound_enabled = true
    }


    Item {
        width: page.width
        anchors.top: parent.top
        anchors.left: _sidebar.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: -units.scale(1)

        Connections {
            target: app
            onWidthChanged: width = app.width
        }

        Column {
            anchors.fill: parent
            enabled: opacity > 0
            spacing: units.gu(1.2)
            opacity: _messageStack.opacity > 0 ? 0 : 1

            Behavior on opacity {NumberAnimation{}}

            Item {
                width: units.gu(1)
                height: parent.height * 0.18
            }

            Icon {
                centered: true
                name: "comments"
                iconSize: units.gu(16)
            }

            Label {
                centered: true
                fontSize: "large"
                text: {
                    if (_sidebar.connectedUsers > 0)
                        return tr("Chat with your friends")
                    else
                        return tr("Invite some friends to chat...")
                }
            }

            Label {
                centered: true
                fontSize: "small"
                text: {
                    if (_sidebar.connectedUsers > 0)
                        return tr("Use the sidebar to select a buddy to chat with.")
                    else
                        return tr("There are no connected buddies for the moment")
                }
            }

            Item {
                width: units.gu(1)
                height: parent.height * 0.1
            }

            Button {
                iconName: "help"
                text: tr("Get help")
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        MessageStack {
            id: _messageStack
            anchors.fill: parent
        }
    }

    UserSidebar {
        id: _sidebar
        onSelected: _messageStack.setPeer(name, uuid)
        onHideMessageStack: _messageStack.opacity = 0
    }
}
