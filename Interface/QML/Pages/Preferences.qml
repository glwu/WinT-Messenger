//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick 2.0
import "../Widgets"

Page {
    logoImageSource : "qrc:/images/Settings.png"
    logoSubtitle    : qsTr("Customize WinT IM")
    logoTitle       : qsTr("Settings")
    toolbarTitle    : qsTr("Settings")

    property int perfectY: 10 + parent.height / 16 + 5

    Component.onCompleted: label.visible = false

    Column {
        spacing: 8
        y: arrangeFirstItem
        anchors.left        : parent.left
        anchors.right       : parent.right
        anchors.leftMargin  : 48
        anchors.rightMargin : 48

        Label {
            anchors.left : parent.left
            text         : qsTr("Nickname:")
        }

        Textbox {
            id: textBox
            anchors.left    : parent.left
            anchors.right   : parent.right
            placeholderText : qsTr("Please type a nickname")
            text            : settings.value("userName", "unknown")
        }

        CheckBox {
            id: checkbox
            x: textBox.x
            checked: settings.value("mobileOptimized", isMobile)
            onCheckedChanged: {
                label.visible = true
                settings.setValue("mobileOptimized", checked)
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: checkbox.left
                anchors.leftMargin: checkbox.width
                text: qsTr("Optimize interface for touch")
                font.pixelSize: smartFontSize(11)
            }
        }

        Label {
            id: label
            x: checkbox.x
            text: qsTr("Restart the application to apply the changes")
            font.pixelSize: smartFontSize(8)
            color: colors.logoSubtitle
        }
    }
}
