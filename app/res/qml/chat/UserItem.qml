//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../controls"

import QtQuick 2.0

Rectangle {
    property string status: "busy"
    property int unreadMessages: 0
    property bool isSelected: false
    property string uuid: tr("Unknown")
    property string username: tr("Unknown")
    signal selectedChanged(bool selected, string name)

    Connections {
        target: _sidebar
        onSelected: {
            if (_item.username == name)
                isSelected = true
            else
                isSelected = false
        }
    }

    Connections {
        target: search_edit
        onTextChanged: {
            if (name.search(new RegExp(search_edit.text, "i")) >= 0 || !search_edit.text)
                visible = true
            else
                visible = false
        }
    }

    Connections {
        target: bridge
        onDelUser: {
            if (id === user_id)
                _delete.start()
        }
        onDrawMessage: {
            if (from == username && !isSelected && message)
                unreadMessages += 1
        }
    }

    onSelectedChanged: {
        page.setTitle(username)
        _sidebar.selected(username, uuid)
    }

    NumberAnimation {
        to: 0
        id: _delete
        target: _item
        duration: 200
        property: "opacity"
        easing.type: Easing.InOutQuad
        onStopped: {
            _users.cacheBuffer -= _item.height
            _usersModel.remove(index)
            autoAdjustWidth()
        }
    }

    enabled: visible
    border.width: units.scale(1)
    height: visible ? units.gu(6) : 0
    color: _mouseArea.containsMouse || isSelected ? theme.primary : "transparent"
    border.color: _mouseArea.containsMouse || isSelected  ? theme.primary :  "transparent"

    anchors {
        left: parent.left
        right: parent.right
    }

    Image {
        id: _image
        smooth: true
        width: height
        height: units.scale(32)
        sourceSize: Qt.size(width, height)
        source: {
            if (username)
                return "image://profile-pictures/" + uuid
            else
                return "qrc:/faces/faces/generic-user.png"
        }

        anchors {
            left: parent.left
            margins: units.gu(1)
            verticalCenter: parent.verticalCenter
        }

        CircularNotification {
            text: unreadMessages
            opacity: unreadMessages > 0 ? 1 : 0
        }
    }

    Label {
        id: _label
        text: username
        maximumLineCount: 1
        elide: Text.ElideRight
        wrapMode: TextEdit.NoWrap
        color: isSelected || _mouseArea.containsMouse ? theme.navigationBarText :
                                                        theme.logoTitle

        anchors {
            left: _image.right
            right: _status.left
            margins: units.gu(1)
            verticalCenter: _image.verticalCenter
        }

        Rectangle {
            color: "transparent"
            anchors.fill: parent
        }
    }

    Rectangle {
        id: _status
        radius: width / 2
        width: units.scale(16)
        height: units.scale(16)
        anchors.right: parent.right
        anchors.rightMargin: units.gu(1)
        opacity: parent.width < 200 ? 0 : 1
        anchors.verticalCenter: _image.verticalCenter

        color: {
            if (parent.status === "available")
                return theme.success
            else if (parent.status === "unavailable")
                return theme.danger
            else
                return theme.warning
        }

    }

    MouseArea {
        id: _mouseArea
        anchors.fill: parent
        hoverEnabled: !app.mobileDevice
        onClicked: {
            isSelected = !isSelected
            selectedChanged(isSelected, username)

            if (isSelected)
                unreadMessages = 0
        }
    }
}
