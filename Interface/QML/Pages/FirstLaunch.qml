//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0
import QtQuick.Dialogs 1.1
import "../Widgets"

Page {
    backButtonEnabled : false
    logoImageSource   : "qrc:/images/Doc/First.png"
    logoSubtitle      : qsTr("Please type your nickname")
    logoTitle         : qsTr("Initial setup")
    toolbarTitle      : qsTr("Initial setup")

    property int perfectY: 10 + parent.height / 16

    Component.onCompleted: enableSettingsButton(false)

    Column {
        spacing: 8
        y: arrangeFirstItem
        anchors.left        : parent.left
        anchors.right       : parent.right
        anchors.leftMargin  : 24
        anchors.rightMargin : 24

        Label {
            anchors.left : parent.left
            text         : qsTr("Nickname:")
        }

        Textbox {
            id: textBox
            anchors.left    : parent.left
            anchors.right   : parent.right
            placeholderText : qsTr("Please type a nickname")
            Keys.onReturnPressed: {
                settings.setValue("userName", textBox.text)
                settings.setValue("firstLaunch", false);
                Qt.inputMethod.hide()
                finishSetup(textBox.text)
            }
        }
    }

    Button {
        anchors.bottom           : parent.bottom
        anchors.bottomMargin     : perfectY
        anchors.horizontalCenter : parent.horizontalCenter
        text                     : qsTr("Done")
        enabled                  : textBox.length > 0 ? 1 : 0
        onClicked                : {
            settings.setValue("userName", textBox.text)
            settings.setValue("firstLaunch", false);
            Qt.inputMethod.hide()
            finishSetup(textBox.text)
        }
    }
}
