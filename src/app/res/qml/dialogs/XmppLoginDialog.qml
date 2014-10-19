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

Dialog {
    id: dialog
    helpButton: true
    title: "XMPP Login"
    onVisibleChanged: _password_edit.text = ""

    signal xmppConnected

    onClosed: {
        if (connecting) {
            disconnectXmpp()
            _login_button.performActions()
        }
    }

    property int numberOfTries : 0
    property MessageBox gmailMessage
    property bool connecting: false

    function connectXmpp() {
        connecting = false
        gmailMessage.close()
        close()

        _password_edit.text = ""

        _spinnerIcon.hide()
        _warning_label.hide()

        _cancel_button.show()
        _login_button.enabled = true
        _login_button.text = qsTr("Login")

        xmppConnected()
    }

    function disconnectXmpp() {
        connecting = false
        bridge.stopXmpp()

        _spinnerIcon.hide()
        _warning_label.show()
        _cancel_button.show()

        _user_label.anchors.verticalCenterOffset += units.gu(0.5)
        _login_controls.anchors.verticalCenterOffset -= units.gu(2)

        _login_button.text = qsTr("Login")

        numberOfTries += 1
        if (numberOfTries >= 2 && _user_edit.text.match("@gmail.com")) {
            close()
            gmailMessage.open()
            numberOfTries = 0
        }
    }

    Connections {
        target: bridge
        onXmppConnected: connectXmpp()
        onXmppDisconnected: disconnectXmpp()
    }

    contents: Column {
        id: column

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: _buttons.top
        anchors.bottomMargin: units.gu(1)

        spacing: units.gu(1)

        Icon {
            id: _logo
            name: "user"
            centered: true
            color: theme.textColor
            iconSize: units.gu(12)

        }

        Label {
            centered: true
            id: _user_label
            fontSize: "large"
            color: theme.logoTitle
            text: qsTr("Sign in to chat online")
        }

        Item {
            id: spacer
            width: units.gu(1)

            Component.onCompleted: height = calculateHeight()

            Connections {
                target: app
                onHeightChanged: spacer.height = spacer.calculateHeight()
            }

            // MAGIC!! DO NOT TOUCH!!
            function calculateHeight() {
                var constant = dialog.height <= dialog.width ? 3 : 8
                var height = ((_buttons.y - _login_controls.y) / constant) - (3 * _spinnerIcon.height)
                return height
            }
        }

        Icon {
            opacity: 0
            centered: true
            id: _spinnerIcon
            name: "fa-spinner"
            onRotationChanged: rotation += 90
            Component.onCompleted: rotation = 1
            height: opacity > 0 ? units.gu(3.125) : units.gu(1)

            Behavior on height {NumberAnimation{}}
            Behavior on opacity {NumberAnimation{}}
            Behavior on rotation {NumberAnimation{}}

            function show() {
                opacity = 1
            }

            function hide() {
                opacity = 0
            }
        }

        Column {
            id: _login_controls
            spacing: units.gu(0.5)
            width: parent.width - units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                opacity: 0
                color: "red"
                id: _warning_label
                width: _login_controls.width
                height: opacity > 0 ? units.gu(2) : 0
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Verify that your user and password are correct")

                Behavior on height {NumberAnimation{}}
                Behavior on opacity {NumberAnimation{}}

                function show() {
                    opacity = 1
                    bridge.playSound("alert")
                }

                function hide() {
                    opacity = 0
                }
            }

            LineEdit {
                id: _user_edit
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: units.gu(1.5)
                text: settings.value("xmpp_nickname", "")
                onTextChanged: settings.setValue("xmpp_nickname", text)
                placeholderText: qsTr("Username (for example user@chat.facebook.com)")
            }

            LineEdit {
                id: _password_edit
                anchors.left: parent.left
                anchors.right: parent.right
                echoMode: TextInput.Password
                anchors.margins: units.gu(1.5)
                placeholderText: qsTr("Password")
            }
        }
    }

    Item {
        id: _buttons
        width: parent.width
        height: _cancel_button.height
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: parent.height * (1 / 6) - units.gu(2)

        Button {
            id: _cancel_button
            onClicked: close()
            text: qsTr("Cancel")
            anchors.right: center.left
            visible: opacity > 0

            Behavior on opacity {NumberAnimation{}}

            function show() {
                opacity = 1
                _login_button.anchors.left = center.right
                _login_button.anchors.horizontalCenter = undefined
            }

            function hide() {
                opacity = 0
                _login_button.anchors.left = undefined
                _login_button.anchors.horizontalCenter = parent.horizontalCenter
            }
        }

        Item {
            id: center
            width: units.scale(24)
            anchors.centerIn: parent
        }

        Button {
            id: _login_button
            style: "primary"
            text: qsTr("Login")
            anchors.left: center.right
            onClicked: performActions()
            enabled: _user_edit.length > 0 && _password_edit.length > 0 ? 1 : 0

            function performActions() {
                if (text === qsTr("Login")) {
                    connecting = true
                    _spinnerIcon.show()
                    _warning_label.hide()
                    _cancel_button.hide()

                    text = qsTr("Stop Operation")
                    bridge.startXmpp(_user_edit.text, _password_edit.text)
                }

                else if (text === qsTr("Stop Operation")) {
                    connecting = false
                    _spinnerIcon.hide()
                    _warning_label.hide()
                    _cancel_button.show()

                    text = qsTr("Login")
                    bridge.stopXmpp()
                }
            }
        }
    }
}
