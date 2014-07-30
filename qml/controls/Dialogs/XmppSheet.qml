//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../Core"
import QtQuick 2.1

//--------------------------------------------------------------------------------------//
// This sheet allows the user to login to an XMPP server and initializes the XMPP chat. //
//--------------------------------------------------------------------------------------//

Sheet {
    // Set the title of the dialog
    title: "XMPP Login"
    buttonsEnabled: false

    onVisibleChanged: password.text = ""

    Rectangle {
        anchors.fill: parent
        //spacing: device.ratio(12)
        anchors.margins: device.ratio(12)
        anchors.horizontalCenter: parent.horizontalCenter

        // Generate the XMPP logo
        Image {
            id: logo
            width: device.ratio(128)
            height: device.ratio(128)
            source: "qrc:/icons/XMPP.svg"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Generate the separator
        Rectangle {
            id: separator
            width: device.ratio(24)
            height: device.ratio(24)
            anchors.top: logo.bottom
        }

        // Generate the warning label
        Label {
            opacity: 0
            color: "red"
            id: warningLabel
            anchors.top: separator.bottom
            text: "Verify that the user and password are correct"

            Behavior on opacity {NumberAnimation{}}
        }

        // Generate the user name controls
        Item {
            id: userControls
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: warningLabel.bottom
            anchors.topMargin: device.ratio(24)

            // Generate the lavel
            Label {
                id: userlabel
                text: qsTr("User name:")
                anchors.left: parent.left
            }

            // Generate the username text field
            TextField {
                id: username
                anchors.right: parent.right
                anchors.left: userlabel.right
                anchors.margins: device.ratio(12)
                text: settings.value("xmpp_username", "")
                anchors.verticalCenter: userlabel.verticalCenter
                onTextChanged: settings.setValue("xmpp_username", text)
                placeholderText: qsTr("Username (for example user@chat.fb.com)")
            }
        }

        // Generate the paddword controls
        Item {
            id: passwordControls
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: userControls.bottom
            anchors.topMargin: device.ratio(36)

            // Generate the lavel
            Label {
                id: passwdlabel
                text: qsTr("Password:")
                anchors.left: parent.left
                width: userlabel.paintedWidth
            }

            // Generate the username text field
            TextField {
                id: password
                anchors.right: parent.right
                echoMode: TextInput.Password
                anchors.left: passwdlabel.right
                anchors.margins: device.ratio(12)
                placeholderText: qsTr("Password")
                anchors.verticalCenter: passwdlabel.verticalCenter
            }
        }

        // Generate the buttons
        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: device.ratio(48)
            anchors.top: passwordControls.bottom

            // Generate the cancel button
            Button {
                onClicked: close()
                text: qsTr("Cancel")
                anchors.right: center.left
            }

            // Create the central item to center the buttons
            Item {
                id: center
                width: device.ratio(24)
                anchors.centerIn: parent
            }

            // Generate the login button
            Button {
                style: "primary"
                text: qsTr("Login")
                anchors.left: center.right
                enabled: username.length > 0 && password.length > 0 ? 1 : 0

                onClicked: {
                    if (bridge.startXmppChat(username.text, password.text)) {
                        close()
                        app.push(xmpp_chat)
                        warningLabel.opacity = 0
                    }

                    else
                        warningLabel.opacity = 1
                }
            }
        }
    }
}
