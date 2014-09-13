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
    helpButton: true
    title: "XMPP Login"
    onVisibleChanged: _password_edit.text = ""

    signal xmppConnected

    property int numberOfTries : 0
    property MessageBox gmailMessage

    Connections {
        target: bridge
        onXmppConnected: {
            gmailMessage.close()
            close()

            _password_edit.text = ""

            _spinnerIcon.hide()
            _warning_label.hide()

            _time_label.hide()
            _cancel_button.show()
            _login_button.enabled = true
            _login_button.text = tr("Login")

            _taking_too_long_timer.stop()
            _cancel_if_taking_longer.stop()

            xmppConnected()
        }

        onXmppDisconnected: {
            bridge.stopXmpp()

            _spinnerIcon.hide()
            _warning_label.show()
            _cancel_button.show()
            _taking_too_long_timer.stop()
            _cancel_if_taking_longer.stop()

            _user_label.anchors.verticalCenterOffset += units.gu(0.5)
            _login_controls.anchors.verticalCenterOffset -= units.gu(2)

            _login_button.text = tr("Login")

            numberOfTries += 1
            if (numberOfTries >= 2 && _user_edit.text.match("@gmail.com")) {
                close()
                gmailMessage.open()
                numberOfTries = 0
            }
        }
    }

    contents: Item {
        anchors.fill: parent

        Icon {
            id: _logo
            name: "user"
            centered: true
            color: theme.iconColor
            iconSize: units.gu(12)
            anchors.bottom: _user_label.top
        }

        Label {
            id: _user_label
            fontSize: "large"
            color: theme.logoTitle
            anchors.centerIn: parent
            text: tr("Sign in to chat online")
            anchors.verticalCenterOffset: -_logo.height / 2
            Behavior on anchors.verticalCenterOffset {NumberAnimation{}}
        }

        Label {
            opacity: 0
            color: "red"
            id: _warning_label
            width: _login_controls.width
            anchors.margins: units.gu(0.5)
            anchors.bottom: _login_controls.top
            horizontalAlignment: Text.AlignHCenter
            Behavior on opacity {NumberAnimation{}}
            anchors.horizontalCenter: parent.horizontalCenter
            text: tr("Verify that your user and password are correct")

            function show() {
                opacity = 1
                bridge.playSound("alert")
            }

            function hide() {
                opacity = 0
            }
        }

        Label {
            opacity: 0
            id: _time_label
            width: _login_controls.width
            anchors.margins: units.gu(0.5)
            anchors.bottom: _login_controls.top
            onTextChanged: height = paintedHeight
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on opacity {NumberAnimation{}}

            function show() {
                opacity = 1
            }

            function hide() {
                text = ""
                opacity = 0
            }
        }

        Timer {
            interval: 7500
            id: _taking_too_long_timer
            onTriggered: {
                _time_label.show()
                _cancel_if_taking_longer.start()
                _time_label.color = theme.notificationBorder
                _time_label.text = tr("The process is taking longer than expected...")
            }
        }

        Timer {
            interval: 11500
            id: _cancel_if_taking_longer
            onTriggered: {
                bridge.playSound("alert")
                _login_button.performActions()

                _time_label.show()
                _time_label.color = "red"
                _time_label.text = tr("Verify that your service provider supports XMPP")
            }
        }

        Icon {
            opacity: 0
            centered: true
            id: _spinnerIcon
            name: "fa-spinner"
            iconSize: units.gu(4)
            onRotationChanged: rotation += 90
            anchors.bottom: _time_label.top
            anchors.bottomMargin: units.gu(0.5)
            Component.onCompleted: rotation = 1
            height: opacity > 0 ? units.gu(4) : units.gu(2)

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
            anchors.centerIn: parent
            width: parent.width - units.gu(3)
            anchors.verticalCenterOffset: parent.height / 8
            Behavior on anchors.verticalCenterOffset {NumberAnimation{}}

            LineEdit {
                id: _user_edit
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: units.gu(1.5)
                text: settings.value("xmpp_nickname", "")
                onTextChanged: settings.setValue("xmpp_nickname", text)
                placeholderText: tr("Username (for example user@chat.facebook.com)")
            }

            LineEdit {
                id: _password_edit
                anchors.left: parent.left
                anchors.right: parent.right
                echoMode: TextInput.Password
                anchors.margins: units.gu(1.5)
                placeholderText: tr("Password")
            }
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: units.gu(2)
            anchors.top: _login_controls.bottom

            Button {
                id: _cancel_button
                onClicked: close()
                text: tr("Cancel")
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
                text: tr("Login")
                anchors.left: center.right
                onClicked: performActions()
                enabled: _user_edit.length > 0 && _password_edit.length > 0 ? 1 : 0

                function performActions() {
                    if (text === tr("Login")) {
                        _time_label.hide()
                        _spinnerIcon.show()
                        _warning_label.hide()
                        _cancel_button.hide()
                        _taking_too_long_timer.start()

                        _user_label.anchors.verticalCenterOffset -= units.gu(0.5)
                        _login_controls.anchors.verticalCenterOffset += units.gu(2)

                        text = tr("Stop Operation")
                        bridge.startXmpp(_user_edit.text, _password_edit.text)
                    }

                    else if (text === tr("Stop Operation")) {
                        _time_label.hide()
                        _spinnerIcon.hide()
                        _warning_label.hide()
                        _cancel_button.show()

                        _taking_too_long_timer.stop()
                        _cancel_if_taking_longer.stop()

                        _user_label.anchors.verticalCenterOffset += units.gu(0.5)
                        _login_controls.anchors.verticalCenterOffset -= units.gu(2)

                        text = tr("Login")
                        bridge.stopXmpp()
                    }
                }
            }
        }
    }
}
