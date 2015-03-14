
//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  Please check the license.txt file for more information.
//

import "../controls"

import QtQuick 2.2
import QtGraphicalEffects 1.0

Frame {
    id: _sidebar

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    color: theme.background

    property alias userCount: _users.count

    Behavior on width {NumberAnimation{}}

    signal hideMessageStack
    signal selected(string name, string uuid)

    property alias connectedUsers: _usersModel.count

    function sidebarFitsScreen() {
        return app.width >= units.scale(240) && app.width > app.height
    }

    function show() {
        if (sidebarFitsScreen())
            width = units.scale(240)
        else
            width = app.width * 0.75
    }

    function hide() {
        width = 0
        if (_users.count <= 0)
            hideMessageStack()
    }

    Connections {
        target: app
        onWidthChanged: {
            var m_width
            if (sidebarFitsScreen())
                m_width = units.scale(240)
            else
                m_width = app.width * 0.75

            if (width > 0)
                width = m_width
        }
    }

    Connections {
        target: bridge
        onNewUser: addUser(nick, id)
    }

    ListModel {
        id: _usersModel
    }

    function clear() {
        _usersModel.clear()
        search_edit.text = ""
    }

    function addUser(name, user_id) {
        _usersModel.append({"name": name, "user_id": user_id})
        autoAdjustWidth()
    }

    function autoAdjustWidth() {
        if (_usersModel.count >= 1)
            show()
    }

    Item {
        id: _panel
        anchors.fill: parent

        Frame {
            z: 2
            id: searchItem
            height: units.gu(5.6)
            color: theme.background

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Icon {
                id: _search
                name: "search"
                iconSize: units.gu(2)
                anchors.left: parent.left
                anchors.margins: units.gu(2)
                opacity: _sidebar.width > 0 ? 1 : 0
                anchors.verticalCenter: parent.verticalCenter
            }

            LineEdit {
                id: search_edit
                anchors.left: _search.right
                anchors.right: parent.right
                visible: _sidebar.width > 0
                anchors.leftMargin: units.gu(2)
                anchors.rightMargin: units.gu(2)
                placeholderText: qsTr("Search users...")
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Label {
            fontSize: "medium"
            text: qsTr("No users available")
            anchors.centerIn: parent
            opacity: _usersModel.count <= 0 && _sidebar.width > 0 ? 1 : 0
            Behavior on opacity {NumberAnimation{}}
        }

        NiceScrollView {
            z: 1
            clip: true
            id: scrollview
            anchors.fill: parent
            anchors.topMargin: searchItem.height - units.scale(1)

            ListView {
                z: 1
                id: _users
                model: _usersModel
                anchors.fill: parent

                Connections {
                    target: search_edit
                    onTextChanged: {
                        _users.update()
                        _users.positionViewAtBeginning()
                    }
                }

                delegate: UserItem {
                    id: _item
                    username: name
                    uuid: user_id
                    onSelectedChanged: {
                        if (!sidebarFitsScreen())
                            _sidebar.hide()
                    }

                    Component.onCompleted: {
                        _users.cacheBuffer += _item.height
                    }
                }
            }
        }
    }
}
