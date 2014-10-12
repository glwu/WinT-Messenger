//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
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

    // This is the inital start page, which allows the user
    // to get help and to open the connect page
    Start {
        id: _start
        onHelpClicked: _helpDialog.open()
        onNewsClicked: _newsDialog.open()
        onChatClicked: stack.push(_connect)
    }

    // This page allows the user to select between chating locally and
    // online - or to get help
    Connect {
        id: _connect
        onOnlineChatClicked: _xmppDialog.open()
        onLocalChatClicked: {
            bridge.startLanChat()
            stack.push(_chat_interface)
            _chat_interface.setTitle("Local Chat")
        }
    }

    // This is a page which represents the actual chat interface,
    // where you can read and send messages to a select group of users
    ChatInterface {
        id: _chat_interface
    }

    // This dialog downloads an RSS file from our page and presents it
    // nicelly to the user
    NewsDialog {
        id: _newsDialog
    }

    // This dialog allows the user to get support
    HelpDialog {
        id: _helpDialog
        onSupportClicked: Qt.openUrlExternally("mailto:alex.racotta@gmail.com")
        onBugClicked: Qt.openUrlExternally("https://github.com/wint-3794/wint-messenger/issues")
        onDocClicked: Qt.openUrlExternally("http://wint-im.sf.net/documentation/documentation.html")
    }

    // This dialog allows the user to login to an XMPP server
    // and show up the chat interface
    XmppLoginDialog {
        id: _xmppDialog
        gmailMessage: _gmailMessage
        onXmppConnected: {
            stack.push(_chat_interface)
            _chat_interface.setTitle("Online Chat")
        }
    }

    // This message will be shown in the case that:
    //   - The account is a Google/Gmail account and:
    //       - The user forgot his/her fucking password
    //       - The user account does not trust XMPP clients
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
