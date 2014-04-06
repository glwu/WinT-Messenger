//
//  This file is part of the WinT Messenger
//
//  Created on Mar, 19, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../../Widgets"

Page {
    flickable    : false
    logoEnabled  : false
    toolbarTitle : qsTr("Setup Hotspot")

    function meetsRequirements() {
        if (ssidTextbox.length > 0
                && ssidTextbox.length <= 32
                && passwordTextbox.length >= 8
                && passwordTextbox.length <= 63)
            return true;

        else
            return false;
    }

    function updateStatus() {
        if (bridge.hotspotEnabled()) {
            connectButton.text = qsTr("Stop hotspot")
            ssidTextbox.enabled = false
            passwordTextbox.enabled = false

            control.enabled = true
            control.setText(qsTr("Welcome to your chat room!"), "gray")
        }

        else {
            connectButton.text = qsTr("Start hotspot")
            ssidTextbox.enabled = true
            passwordTextbox.enabled = true

            control.enabled = false
            control.setText(qsTr("<h2>How to setup and use a wireless hotspot</h2>"
                                 + "<ol>"
                                 + "<li>One of your peers (or you) must create a wireless hotspot using the form at the top of this screen.</li>"
                                 + "<li>Afer he/she finishes creating the form, you will see his phone/device appear as a normal router in your network settings.</li>"
                                 + "<li>Connect to the newly created hotspot and press the \"Local Network\" button on the connect screen.</li>"
                                 + "</ol>"
                                 + "<font color=blue><i><strong>NOTE:&nbsp;</strong>For the moment, you can create a wireless hotspot only on Windows. Support for other operating systems will come soon.</i></font>"
                                 + "<p><font color=red><strong>This is an experimental feature and it may not work as expected!</font></p>"), "black")
        }
    }

    Component.onCompleted: {
        enableAboutButton(false)
        enableSettingsButton(false)
        updateStatus()
    }

    onVisibleChanged: {
        enableAboutButton(!visible)
        enableSettingsButton(!visible)

        if (!visible)
            bridge.stopHotspot()

        updateStatus()
    }

    Rectangle {
        id: chatInterface

        anchors.top: wizard.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        color: "transparent"

        ChatInterface {
            anchors.fill: parent
            id: control
        }
    }

    Rectangle {
        id: wizard
        anchors.left: parent.left
        anchors.right: parent.right

        color: colors.buttonBackgroundPressed
        border.color: colors.borderColor

        y: toolbar.height
        height: ssidTextbox.height + connectButton.height + passwordTextbox.height + bridge.ratio(16)

        Textbox {
            id: ssidTextbox
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: bridge.ratio(4)

            placeholderText: qsTr("Enter your WiFi hotspot name here (SSID)...")
        }

        Textbox {
            id: passwordTextbox
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: bridge.ratio(4)

            y: ssidTextbox.y + ssidTextbox.height + bridge.ratio(4)
            echoMode: TextInput.Password

            placeholderText: qsTr("Enter your password...")
        }

        Button {
            id: connectButton
            anchors.horizontalCenter: parent.horizontalCenter
            enabled : meetsRequirements() ? 1 : 0

            y: passwordTextbox.y + passwordTextbox.height + bridge.ratio(4)

            onClicked : {
                if (!bridge.hotspotEnabled()) {
                    if (meetsRequirements()) {
                        bridge.startHotspot(ssidTextbox.text, passwordTextbox.text)
                        settings.setValue("ssid", ssidTextbox.text)
                        updateStatus()
                    }
                }

                else {
                    bridge.stopHotspot()
                    updateStatus()
                }
            }
        }
    }
}
