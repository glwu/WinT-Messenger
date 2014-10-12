//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import QtQuick 2.0
import "../controls"

MessageBox {
    icon: "bitcoin"
    id: _donate_bitcoins
    title: qsTr("Donate Bitcoins")
    caption: qsTr("Donate Bitcoins")
    details: qsTr("You can donate Bitcoins to the following address")

    data: Column {
        spacing: units.gu(1)
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            id: _address
            text: bitAddress
            color: theme.success
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: units.size("small")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Button {
            width: units.scale(200)
            text: qsTr("Copy address to clipboard")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                bridge.copy(_address.text)
                notification.show(qsTr("Bitcoin address copied successfully!"))
            }
        }

        Button {
            width: units.scale(200)
            text: qsTr("Learn more about Bitcoin")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                _donate_bitcoins.close()
                Qt.openUrlExternally("https://bitcoin.org")
            }
        }

    }
}
