//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
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
    title: tr(appName)
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

    Start {
        id: _start
        onHelpClicked: _helpDialog.open()
        onNewsClicked: _newsDialog.open()
        onChatClicked: stack.push(_connect)
    }

    Connect {
        id: _connect
        onOnlineChatClicked: _xmppDialog.open()
        onLocalChatClicked: {
            bridge.startLanChat()
            stack.push(_chat_interface)
            _chat_interface.setTitle("Local Chat")
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
        onSupportClicked: Qt.openUrlExternally("mailto:alex.racotta@gmail.com")
        onBugClicked: Qt.openUrlExternally("https://github.com/wint-3794/wint-messenger/issues")
        onDocClicked: Qt.openUrlExternally("http://wint-im.sf.net/documentation/documentation.html")
    }

    XmppLoginDialog {
        id: _xmppDialog
        gmailMessage: _gmailMessage
        onXmppConnected: {
            stack.push(_chat_interface)
            _chat_interface.setTitle("Online Chat")
        }
    }

    MessageBox {
        id: _gmailMessage
        icon: "google"
        title: tr("Login to Google")
        caption: tr("Cannot login to your Google account?")
        details: tr("You may need to allow your account to use third-party chat apps")

        onClosed: _xmppDialog.open()

        data: Item {
            Column {
                spacing: units.gu(1)
                anchors.centerIn: parent
                anchors.verticalCenterOffset: units.gu(1)

                Button {
                    width: units.scale(200)
                    text: tr("Configure my Google account")
                    onClicked: {
                        _gmailMessage.close()
                        _xmppDialog.open()
                        Qt.openUrlExternally("https://www.google.com/settings/security/lesssecureapps")
                    }
                }

                Button {
                    width: units.scale(200)
                    text: tr("Recover my password")
                    onClicked: {
                        _gmailMessage.close()
                        _xmppDialog.open()
                        Qt.openUrlExternally("https://www.google.com/accounts/recovery/")
                    }
                }
            }
        }
    }
}
