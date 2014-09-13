
//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../controls"

import QtQuick 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.2 as Controls

Rectangle {
    id: _sidebar

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    color: theme.background
    border.width: units.scale(1)
    border.color: theme.borderColor

    Behavior on width {NumberAnimation{}}

    signal hideMessageStack
    signal selected(string name, string uuid)

    property alias connectedUsers: _usersModel.count

    function show() {
        if (app.width >= units.scale(240) && app.width > app.height)
            width = units.scale(240)
        else
            width = app.width
    }

    function hide() {
        width = 0
    }

    Connections {
        target: app
        onWidthChanged: {
            var m_width
            if (app.width >= units.scale(240) && app.width > app.height)
                m_width = units.scale(240)
            else
                m_width = app.width

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
    }

    function addUser(name, user_id) {
        _usersModel.append({"name": name, "user_id": user_id})
        autoAdjustWidth()
    }

    function autoAdjustWidth() {
        if (_usersModel.count >= 1)
            show()
        else if (_usersModel.count >= 1)
            return
        else
            hide()
    }

    Rectangle {
        z: 2
        id: searchItem
        height: units.gu(5.6)
        border.width: units.scale(1)
        border.color: theme.borderColor
        color: settings.darkInterface() ? theme.dialog : theme.background

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
            anchors.leftMargin: units.gu(2)
            anchors.rightMargin: units.gu(2)
            placeholderText: tr("Search...")
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Controls.ScrollView {
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

                Component.onCompleted: {
                    _users.cacheBuffer += _item.height
                }
            }
        }
    }
}
