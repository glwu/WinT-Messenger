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
    backButtonEnabled   : false
    logoImageSource     : "qrc:/images/Logo.png"
    logoSubtitle        : qsTr("Please choose an option")
    logoTitle           : qsTr("Welcome")
    toolbarTitle        : qsTr("Start")

    property int perfectY: arrangeFirstItem + parent.height / 32


    Column {
        spacing: 8
        y: perfectY
        anchors.horizontalCenter : parent.horizontalCenter

        Button {
            onClicked : openPage("Pages/Connect.qml")
            text      : qsTr("Connect")
        }

        Button {
            onClicked : openPage("Pages/Donate.qml")
            text      : qsTr("Donate")
        }

        Button {
            onClicked : openPage("Pages/Help/Help.qml")
            text      : qsTr("Help")
        }
    }
}
