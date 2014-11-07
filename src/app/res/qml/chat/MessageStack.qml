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
import QtMultimedia 5.0

Item {
    opacity: 0
    id: messageStack

    property string peer
    property string uuid

    property bool peer_disconnected: false

    signal userButtonClicked
    signal userChanged(string user)

    Behavior on opacity {NumberAnimation{}}

    function drawMessage(from, to,  message, isLocal) {
        if (message) {
            if (!peer_disconnected) {
                _status.opacity = 0
                receiveSound.play()
            }

            _bubble_model.append({"_from": from,
                                     "_to": to,
                                     "_message": message,
                                     "_isLocal": isLocal})

            _bubble_view.positionViewAtEnd()
        }
    }

    function clear() {
        _bubble_model.clear()
    }

    function setPeer(nickname, id) {   
        peer = nickname
        uuid = id
        opacity = 1
        userChanged(nickname)
        peer_disconnected = false
        _bubble_view.positionViewAtEnd()
    }

    onVisibleChanged: {
        if (!visible)
            _status.text = ""
    }

    Connections {
        target: bridge
        onDelUser: {
            if (id === uuid) {
                peer_disconnected = true
                _status.text = peer + " " + qsTr("is no longer available")
            }
        }

        onDrawMessage: {
            drawMessage(from, "local user", message, false)
        }
    }

    SoundEffect {
        id: sendSound
        source: "qrc:/sounds/sounds/send.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }

    SoundEffect {
        id: receiveSound
        source: "qrc:/sounds/sounds/receive.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }

    SoundEffect {
        id: alertSound
        source: "qrc:/sounds/sounds/alert.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }


    NiceScrollView {
        anchors {
            fill: parent
            bottomMargin: _chat_controls.height * 1.2 + _status.height
        }

        ListView {
            id: _bubble_view
            anchors.fill: parent
            anchors.topMargin: units.gu(1)

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
                        return "local"
                    else
                        return "remote"
                }

                Component.onCompleted: {
                    assignConversation(peer)
                }
            }
        }
    }

    Label {
        id: _status
        centered: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: _chat_controls.height * 1.25

        Behavior on opacity {NumberAnimation{}}

        Timer {
            id: _timer
            interval: 500
            onTriggered: !peer_disconnected ? _status.opacity = 0 : undefined
        }

        function show() {
            _status.opacity = 1
            _timer.restart()
        }

        Connections {
            target: bridge
            onStatusChanged: {
                if (status == "composing" && from == uuid) {
                    _status.text = peer + " " + qsTr("is typing") + "..."
                    _status.show()
                }

                if (status == "seen" && from == uuid) {
                    _status.text = qsTr("Seen at") + Qt.formatDateTime(new Date(), " hh:mm:ss AP")
                    _status.opacity = 1
                }
            }
        }
    }

    ChatControls {
        id: _chat_controls

        onShareFileClicked: bridge.shareFiles(uuid)
        onUserIsWriting: bridge.sendStatus(uuid, "composing")
        onUserButtonClicked: messageStack.userButtonClicked()

        onNewMessage: {
            if (message) {
                bridge.sendMessage(uuid, message)
                drawMessage("local user", peer, message, true)
            } else {
                alertSound.play()
            }
        }
    }
}
