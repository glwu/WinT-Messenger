//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../Core"
import "../Dialogs"

import QtQuick 2.2
import QtQuick.Controls 1.2 as Controls

//--------------------------------------------------------------------------//
// This page allows the user to read and send messages through the network. //
// Please note that this page only sends and reads data from the \c Bridge, //
// this means that this control can be easilly implemented to support many  //
// chat platforms and is not limited to the LAN chat feature.               //
//--------------------------------------------------------------------------//

Page {
    id: chat
    title: qsTr("Chat")
    anchors.fill: parent

    // Show a warning message on mobile devices if
    // the user tries to open a local file
    function openUrl(url) {
        Qt.openUrlExternally(url)
        console.log("Opening URL: " + url)

        if (device.isMobile()) {
            if (url.search("file:///") !== -1) {
                url = url.replace("file://", "")
                downloadMenu.close()
                warningMessage.open()
                warningMessage.text = qsTr("Cannot open file directly from WinT Messenger, " +
                                           "your file was download here: " + url +
                                           "<br>If you want to learn more about this error, " +
                                           "<a href=https://github.com/WinT-3794/WinT-Messenger/issues/3>click here</a>.")
            }
        }
    }

    // Show a notification when an user leaves or enters the room
    Connections {
        target: bridge
        onDelUser: notification.show(qsTr("%1 has left the room").arg(nick))
        onNewUser: {
            userSidebar.addUser(nick, face)
            notification.show(qsTr("%1 has joined the room").arg(nick))
        }
    }

    // Create the save button near the back button
    leftWidgets: [

        // Make a button that allows the user to save the chat file
        Button {
            flat: true
            iconName: "save"
            visible: !device.isMobile()
            enabled: !device.isMobile()
            textColor: theme.navigationBarText
            onClicked: device.isMobile() ? dialog.open() : bridge.saveChat(textEdit.text)
        },

        // Create a button that displays and manages downloads
        Button {
            flat: true
            id: lDownloadButton
            iconName: "download"
            visible: device.isMobile()
            enabled: device.isMobile()
            onClicked: downloadMenu.toggle(caller)
            textColor: downloadMenu.visible ? theme.getSelectedColor(true) : theme.navigationBarText

            // Create the badge that displays the number of downloads
            Badge {
                text: downloadMenu.activeDownloads
            }
        }
    ]

    // Create the right widgets, such as the user menu and the app menu
    rightWidgets: [

        // Create a button that displays and manages downloads
        Button {
            flat: true
            id: rDownloadButton
            iconName: "download"
            visible: !device.isMobile()
            enabled: !device.isMobile()
            onClicked: downloadMenu.toggle(caller)
            textColor: downloadMenu.visible ? theme.getSelectedColor(true) : theme.navigationBarText

            // Create the badge that displays the number of downloads
            Badge {
                text: downloadMenu.activeDownloads
            }
        },

        // Make a button that allows the user to toggle the user menu
        Button {
            flat: true
            iconName: "user"
            onClicked: userSidebar.toggle()
            textColor: userSidebar.expanded ? theme.getSelectedColor(true) : theme.navigationBarText

            // Create a badge that displays the number of connected users
            Badge {
                text: userSidebar.userCount
            }
        },

        // Make a button that allows the user to show/hide the application menu
        Button {
            flat: true
            iconName: "bars"
            onClicked: menu.toggle(caller)
            textColor: menu.visible ? theme.getSelectedColor(true) : theme.navigationBarText
        }
    ]

    // Refresh the chat interface when we enter and exit the room
    onVisibleChanged: {
        if (!visible) {
            bridge.stopLanChat()
            bridge.stopXmppChat()

            chatLog.clear()
            userSidebar.clear()
            downloadMenu.exit()
        }

        else {
            chatLog.welcomeUser()
            userSidebar.addUser(settings.value("username", "unknown"), settings.value("face", "astronaut.jpg"))
        }
    }

    // Create a menu that displays and manages downloads
    DownloadMenu {
        id: downloadMenu
    }

    Rectangle {
        anchors.fill: parent

        // Close the emotes menu when the user clicks/taps
        // on any area of the app
        MouseArea {
            anchors.fill: parent
            enabled: !chatLog.textChat
            onClicked: chatControls.emotesMenu.close()
        }

        // Create the emotes menu and the message controls
        ChatControls {
            id: chatControls
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: userSidebar.left
        }

        // Create the area where we display the messages
        ChatLog {
            id: chatLog
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: userSidebar.left
            anchors.bottom: chatControls.top
        }

        // Create a sidebar with the connected users
        UserSidebar {
            id: userSidebar
        }
    }

    // This is the warning message displayed when a mobile user tries to open a local file.
    Sheet {
        id: warningMessage
        buttonsEnabled: false
        title: qsTr("Warning")

        property alias text: label.text

        // Create a column with the icon and the controls
        Column {
            spacing: units.gu(2)

            // Set the anchors of the column
            anchors.centerIn: parent
            anchors.margins: device.ratio(12)

            // Create the error icon
            Icon {
                name: "exclamation"
                fontSize: units.gu(10)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Create the title
            Label {
                fontSize: "x-large"
                text: qsTr("Cannot open file")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Create the subtitle
            Label {
                id: label
                textFormat: Text.RichText
                onLinkActivated: openUrl(link)
                width: warningMessage.width * 0.7
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Finally, create the button to close the message
            Button {
                style: "primary"
                text: qsTr("Close")
                onClicked: warningMessage.close()
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
