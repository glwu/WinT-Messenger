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
import QtQuick.Controls 1.0 as Controls

Item {
    opacity: 0
    id: messageStack

    property string peer
    property string uuid

    signal userChanged(string user)
    Behavior on opacity {NumberAnimation{}}

    function drawMessage(from, to,  message, isLocal) {
        if (message) {
            bridge.playSound("receive")
            _bubble_model.append({"_from": from,
                                     "_to": to,
                                     "_message": message,
                                     "_isLocal": isLocal})

            _bubble_view.positionViewAtEnd()
        }
    }

    function clear() {
        opacity = 0
        _bubble_model.clear()
    }

    function setPeer(nickname, id) {
        peer = nickname
        uuid = id
        opacity = 1

        userChanged(nickname)
        _bubble_view.positionViewAtEnd()
    }

    Connections {
        target: bridge
        onDelUser: {
            if (id === uuid)
                opacity = 0
        }

        onDrawMessage: {
            drawMessage(from, "local user", message, false)
        }
    }

    Controls.ScrollView {
        anchors {
            fill: parent
            bottomMargin: _chat_controls.height
        }

        ListView {
            id: _bubble_view
            anchors.fill: parent

            model: ListModel {
                id: _bubble_model
            }

            delegate: BubbleMessage {
                to: _to
                from: _from
                message: _message
                isLocal: _isLocal
                id: _bubble_message
                state: {
                    if (isLocal)
                        return "LOCAL_USER"
                    else
                        return "REMOTE_USER"
                }

                Component.onCompleted: {
                    assignConversation(peer)
                }
            }
        }
    }

    ChatControls {
        id: _chat_controls
        onNewMessage: {
            if (message) {
                bridge.sendMessage(uuid, message)
                drawMessage("local user", peer, message, true)
            } else {
                bridge.playSound("alert")
            }
        }
    }
}
