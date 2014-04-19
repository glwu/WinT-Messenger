//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import "../Widgets"

Page {
  logoImageSource: "qrc:/images/Connect.png"
  logoTitle: qsTr("Connect")
  toolbarTitle: qsTr("Connect")
  logoSubtitle: qsTr("Please select a communication method")

  Column {
    spacing: DeviceManager.ratio(4)
    y: arrangeFirstItem + parent.height / 32
    anchors.horizontalCenter: parent.horizontalCenter

    Button {
      text: qsTr("Bluetooth chat")
      enabled: !DeviceManager.isMobile()
      onClicked: {
        text = qsTr("Please wait...")
        enabled = false

        Bridge.startBtChat()
        openPage("Pages/Chat.qml")

        text = qsTr("Bluetooth chat")
        enabled = true
      }
    }

    Button {
      text: qsTr("Network (LAN) chat")
      onClicked: {
        text = qsTr("Please wait...")
        enabled = false

        Bridge.startNetChat()
        openPage("Pages/Chat.qml")

        text = qsTr("Network (LAN) chat")
        enabled = true
      }
    }

    Button {
      onClicked: openPage("Pages/Hotspot/Wizard.qml")
      text: qsTr("Setup a wireless hotspot")
    }
  }


}
