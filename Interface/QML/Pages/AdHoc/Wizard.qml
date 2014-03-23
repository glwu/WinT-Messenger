//
//  This file is part of the WinT IM
//
//  Created on Mar, 19, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../../Widgets"

Page {
    logoEnabled  : false
    toolbarTitle : qsTr("Ad-hoc")

    Flickable {
        id: flickable
        anchors.fill       : parent
        anchors.margins    : 16
        anchors.topMargin  : 16 + arrangeFirstItem
        contentHeight      : textView.paintedHeight
        flickableDirection : Flickable.VerticalFlick
        interactive        : true

        function ensureVisible(r) {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        Column {
            id: column
            spacing: smartSize(8)
            anchors.fill: parent

            TextEdit {
                id: textView
                activeFocusOnPress: true

                anchors.left: parent.left
                anchors.right: parent.right

                clip                     : true
                color                    : colors.text
                font.family              : defaultFont
                font.pointSize           : isMobile ? 12 : 8
                onCursorRectangleChanged : flickable.ensureVisible(cursorRectangle)
                readOnly                 : true
                textFormat               : TextEdit.RichText
                wrapMode                 : TextEdit.WordWrap
                onLinkActivated          : stackView.pop()
                text : {
                    qsTr("<!DOCTYPE html>"
                         + "<html>"
                         + "<body>"
                         + "<h2>Introduction</h2>"
                         + "<p>WinT Messenger lets you chat in places where there are no routers "
                         + "by using your device as a WiFi hotspot (in other words, as a virtual router).</p>"
                         + "<h2>How to create an ad-hoc network</h2>"
                         + "<ol>"
                         + "<li>One of your peers (or you) must create a WiFi hotspot using the form at the bottom of this document.</li>"
                         + "<li>Afer he/she finishes creating the form, you will see his phone/device appear as a normal router in your network settings.</li>"
                         + "<li>Connect to the newly created hotspot and press the \"Local Network\" button on the \"<a href='http://wint-im.sf.net'>Connect</a>\" screen.</li>"
                         + "</ol>"
                         + "<h3>Setup an ad-hoc network:</h3>"
                         + "</body>"
                         + "</html>")
                }
            }

            Label {
                text: qsTr("Type your WiFi hotspot name (SSID):")
            }

            Textbox {
                id: ssidTextbox
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 12
                placeholderText: qsTr("Enter your WiFi hotspot name here (SSID)...")
                text: settings.value("ssid", bridge.hostName())
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                enabled : ssidTextbox.text.length > 0 ? 1 : 0
                text: bridge.adHocEnabled() ? qsTr("Stop hotspot") : qsTr("Start hotspot")

                onClicked : {
                    if (!bridge.adHocEnabled()) {
                        if (ssidTextbox.text.length > 0) {
                            // Setup the ad-hoc network
                            bridge.startAdHoc(ssidTextbox.text)
                            settings.setValue("ssid", ssidTextbox.text)

                            if (bridge.adHocEnabled()) {
                                ssidTextbox.enabled = false
                                label.text = qsTr("The ad-hoc hotspot is enabled")
                                label.color = "green"
                                text = qsTr("Stop hotspot")
                            }
                        }
                    }

                    else {
                        // Stop the ad-hoc network
                        bridge.stopAdHoc()

                        if (!bridge.adHocEnabled()){
                            ssidTextbox.enabled = true
                            label.text = qsTr("The ad-hoc hotspot is disabled")
                            label.color = "gray"
                            text = qsTr("Start hotspot")
                        }
                    }
                }
            }
        }
    }

    Label {
        id: label
        text: bridge.adHocEnabled() ? qsTr("The ad-hoc hotspot is enabled") : qsTr("The ad-hoc hotspot is disabled")
        color: bridge.adHocEnabled() ? "green" : "gray"
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.margins: 12
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
