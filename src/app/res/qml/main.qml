//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  Please check the license.txt file for more information.
//

import "chat"
import "core"
import "pages"
import "dialogs"
import "controls"

import QtQuick 2.0

App {
    title: qsTr(appName)
    minimumWidth: units.gu(40)
    minimumHeight: units.gu(60)

    x: settings.x()
    y: settings.y()
    width: settings.width()
    height: settings.height()
    onXChanged: settings.setValue("x", x)
    onYChanged: settings.setValue("y", y)
    onWidthChanged: settings.setValue("width", width)
    onHeightChanged: settings.setValue("height", height)

    initialPage: _start

    function stopChatModules() {
        bridge.stopXmpp()
        bridge.stopLanChat()
    }

    Start {
        id: _start
        onHelpClicked: _helpDialog.open()
        onNewsClicked: _newsDialog.open()
        onChatClicked: stack.push(_connect)
    }

    Connect {
        id: _connect

        onOnlineChatClicked: {
            stopChatModules()
            _xmppDialog.open()
        }

        onLocalChatClicked: {
            stopChatModules()
            bridge.startLanChat()
            stack.push(_chat_interface)
        }
    }

    ChatInterface {
        id: _chat_interface
    }

    NewsDialog {
        id: _newsDialog
    }

    HelpDialog {
        id: _helpDialog
        onSupportClicked: Qt.openUrlExternally("mailto:alex_spataru@outlook.com")
        onBugClicked: Qt.openUrlExternally("https://github.com/wint-3794/wint-messenger/issues")
        onDocClicked: Qt.openUrlExternally("http://wint-im.sf.net/documentation/documentation.html")
    }

    XmppLoginDialog {
        id: _xmppDialog
        gmailMessage: _gmailMessage
        onXmppConnected: {
            stack.push(_chat_interface)
        }
    }

    MessageBox {
        id: _gmailMessage
        icon: "google"
        title: qsTr("Login to Google")
        caption: qsTr("Cannot login to your Google account?")
        details: qsTr("You may need to allow your account to use third-party chat apps")

        onClosed: _xmppDialog.open()

        data: Item {
            Button {
                id: _conf_button
                width: units.scale(200)
                anchors.centerIn: parent
                anchors.verticalCenterOffset: units.gu(2)
                text: qsTr("Configure my Google account")
                onClicked: {
                    _gmailMessage.close()
                    _xmppDialog.open()
                    Qt.openUrlExternally("https://www.google.com/settings/security/lesssecureapps")
                }
            }

            Button {
                width: units.scale(200)
                text: qsTr("Recover my password")
                y: _conf_button.y + height + units.gu(1)
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    _gmailMessage.close()
                    _xmppDialog.open()
                    Qt.openUrlExternally("https://www.google.com/accounts/recovery/")
                }
            }
        }
    }
}
