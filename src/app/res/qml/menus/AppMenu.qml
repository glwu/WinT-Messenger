//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"

import QtQuick 2.0
import QtQuick.Controls 1.0 as Controls

Menu {
    id: _app_menu

    data: Column {
        anchors.centerIn: parent

        Button {
            flat: true
            iconName: "about"
            text: qsTr("About")
            fontSize: "medium"
            width: website.width
            onClicked: _about.open()
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            flat: true
            iconName: "cog"
            fontSize: "medium"
            width: website.width
            text: qsTr("Preferences")
            onClicked: _preferences.open()
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            flat: true
            id: donate
            fontSize: "medium"
            iconName: "bitcoin"
            width: website.width
            text: qsTr("Donate Bitcoins")
            onClicked: _donate.open()
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            flat: true
            id: website
            iconName: "globe"
            fontSize: "medium"
            text: qsTr("WinT 3794 Website")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: Qt.openUrlExternally("http://wint3794.org")
        }
    }
}
