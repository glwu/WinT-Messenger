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
import QtGraphicalEffects 1.0
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
    }

    function removeUser(nickname) {
        if (sound_enabled) {
            soundTimer.start()
            sound_enabled = false
            bridge.playSound("logout")
        }
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

    rightWidgets: [
        Icon {
            name: "download"
            color: theme.navigationBarText
            opacity: _sidebar.sidebarFitsScreen() ? 1 : 0

            Behavior on opacity {
                NumberAnimation{}
            }

            MouseArea {
                anchors.fill: parent
                enabled: parent.opacity > 0
                onClicked: app.downloadMenu.toggle(parent)
            }
        }
    ]

    leftWidgets: [
        Icon {
            name: "download"
            color: theme.navigationBarText
            opacity: _sidebar.sidebarFitsScreen() ? 0 : 1

            Behavior on opacity {
                NumberAnimation{}
            }

            MouseArea {
                anchors.fill: parent
                enabled: parent.opacity > 0
                onClicked: app.downloadMenu.toggle(parent)
            }
        }
    ]

    Rectangle {
        color: theme.dialog
        anchors.fill: parent
    }

    Timer {
        id: soundTimer
        interval: 750
        onTriggered: sound_enabled = true
    }

    MouseArea {
        id: _swipeArea
        anchors.fill: parent
        enabled: !_sidebar.sidebarFitsScreen()

        property point origin
        property bool ready: false
        signal move(int x, int y)
        signal swipe(string direction)

        onPressed: {
            drag.axis = Drag.XAndYAxis
            origin = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: {
            switch (drag.axis) {
            case Drag.XAndYAxis:
                if (Math.abs(mouse.x - origin.x) > 16) {
                    drag.axis = Drag.XAxis
                }
                else if (Math.abs(mouse.y - origin.y) > 16) {
                    drag.axis = Drag.YAxis
                }
                break
            case Drag.XAxis:
                move(mouse.x - origin.x, 0)
                break
            case Drag.YAxis:
                move(0, mouse.y - origin.y)
                break
            }
        }

        onReleased: {
            switch (drag.axis) {
            case Drag.XAndYAxis:
                canceled(mouse)
                break
            case Drag.XAxis:
                swipe(mouse.x - origin.x < 0 ? "left" : "right")
                break
            case Drag.YAxis:
                swipe(mouse.y - origin.y < 0 ? "up" : "down")
                break
            }
        }
    }

    Item {
        id: _mainView
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        function setAnchors() {
            anchors.left =  _sidebar.sidebarFitsScreen() ?
                        _sidebar.right : parent.left
            anchors.leftMargin = _sidebar.sidebarFitsScreen() ?
                        units.scale(-1) : 0
        }

        Component.onCompleted: setAnchors()

        Connections {
            target: app
            onWidthChanged: _mainView.setAnchors()
        }

        Column {
            enabled: opacity > 0
            spacing: units.gu(1.2)
            anchors.centerIn: parent
            opacity: _messageStack.opacity > 0 ? 0 : 1
            anchors.verticalCenterOffset: -_comments_icon.height / 3

            Behavior on opacity {NumberAnimation{}}

            Icon {
                id: _comments_icon
                centered: true
                name: "comments"
                iconSize: units.gu(16)
            }

            Label {
                centered: true
                fontSize: "large"
                text: {
                    if (_sidebar.connectedUsers > 0)
                        return qsTr("Chat with your friends")
                    else
                        return qsTr("Invite some friends to chat...")
                }
            }

            Label {
                centered: true
                fontSize: "small"
                text: {
                    if (_sidebar.connectedUsers > 0)
                        return qsTr("Use the sidebar to select a buddy to chat with.")
                    else
                        return qsTr("There are no connected buddies for the moment")
                }
            }
        }

        MessageStack {
            id: _messageStack
            anchors.fill: parent
            onUserButtonClicked: _sidebar.show()
        }
    }

    Rectangle {
        color: "black"
        anchors.fill: parent
        opacity: _sidebar.width > 0 && !_sidebar.sidebarFitsScreen() ?
                     0.75 : 0.0

        Behavior on opacity {NumberAnimation{}}
    }

    UserSidebar {
        id: _sidebar
        onSelected: _messageStack.setPeer(name, uuid)
        onHideMessageStack: {
            if (page.visible)
                page.setTitle(qsTr("Chat"))

            _messageStack.opacity = 0
        }

        Connections {
            target: _swipeArea
            onSwipe: {
                if (direction == "right") {
                    _sidebar.show()
                    _userIcon.toggled = true
                } else {
                    _sidebar.hide()
                }
            }
        }

        Connections {
            target: app
            onWidthChanged: {
                if (_sidebar.userCount >= 1
                        && _sidebar.sidebarFitsScreen()
                        && _sidebar.width <= 0)
                    _sidebar.show()
            }
        }
    }
}
