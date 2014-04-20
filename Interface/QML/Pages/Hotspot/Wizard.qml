//
//  This file is part of the WinT Messenger
//
//  Created on Mar, 19, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import "../../Widgets"

Page {
    flickable: false
    logoEnabled: false
    toolbarTitle: qsTr("Setup Hotspot")

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
        if (Bridge.hotspotEnabled()) {
            control.enabled = true
            ssidTextbox.enabled = false
            passwordTextbox.enabled = false
            connectButton.text = qsTr("Stop hotspot")
            control.setText(("Welcome to your chat room!"), "gray")
        }

        else {
            control.enabled = false
            ssidTextbox.enabled = true
            passwordTextbox.enabled = true
            connectButton.text = qsTr("Start hotspot")
            control.setText(("<h2>How to setup and use a wireless hotspot</h2>"
                             + "<ol>"
                             + "<li>One of your peers (or you) must create a wireless hotspot using the form at the top of this screen.</li>"
                             + "<li>Afer he/she finishes creating the form, you will see his phone/device appear as a normal router in your network Settings.</li>"
                             + "<li>Connect to the newly created hotspot and press the \"Local Network\" button on the connect screen.</li>"
                             + "</ol>"
                             + "<font color=blue><i><strong>NOTE:&nbsp;</strong>For the moment, you can create a wireless hotspot only on Windows. Support for other operating systems will come soon.</i></font>"
                             + "<p><font color=red><strong>This is an experimental feature and it may not work as expected!</font></p>"), colors.text)
        }
    }

    Component.onCompleted: {
        updateStatus()
        toolbar.controlButtonsEnabled = false
    }

    onVisibleChanged: {
        updateStatus()
        if (!visible) Bridge.stopHotspot()
        toolbar.controlButtonsEnabled = !visible
    }

    Rectangle {
        id: chatInterface
        anchors {fill: parent; topMargin: wizard.height + arrangeFirstItem}
        color: "transparent"

        ChatInterface {
            anchors.fill: parent
            id: control
        }
    }

    Rectangle {
        id: wizard
        y: toolbar.height
        border.color: colors.borderColor
        color: colors.buttonBackgroundPressed
        anchors {right: parent.right; left: parent.left;}
        height: ssidTextbox.height + connectButton.height + passwordTextbox.height + DeviceManager.ratio(16)

        Textbox {
            id: ssidTextbox
            placeholderText: qsTr("Enter your WiFi hotspot name here (SSID)...")
            anchors {top: parent.top; right: parent.right; left: parent.left; margins: DeviceManager.ratio(4)}
        }

        Textbox {
            id: passwordTextbox
            echoMode: TextInput.Password
            placeholderText: qsTr("Enter your password...")
            y: ssidTextbox.y + ssidTextbox.height + DeviceManager.ratio(4)
            anchors {left: parent.left; right: parent.right; margins: DeviceManager.ratio(4)}
        }

        Button {
            id: connectButton
            enabled: meetsRequirements() ? 1: 0
            anchors.horizontalCenter: parent.horizontalCenter
            y: passwordTextbox.y + passwordTextbox.height + DeviceManager.ratio(4)
            onClicked: {
                if (!Bridge.hotspotEnabled()) {
                    if (meetsRequirements()) {
                        Bridge.startHotspot(ssidTextbox.text, passwordTextbox.text)
                        updateStatus()
                    }
                }

                else {
                    Bridge.stopHotspot()
                    updateStatus()
                }
            }
        }
    }
}
