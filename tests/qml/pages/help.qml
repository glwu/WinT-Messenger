//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import "../controls" as Controls

Controls.Page {
    title: qsTr("Help")
    toolbarTitle: qsTr("Help")
    imageSource: "qrc:/icons/Help.svg"
    subtitle: qsTr("Learn the basics behind the app")

    Column {
        y: arrangeFirstItem
        spacing: device.ratio(4)
        anchors.horizontalCenter: parent.horizontalCenter

        Controls.Button {
            text: qsTr("Documentation")
            onClicked: Qt.openUrlExternally("http://wint-im.sf.net/doc/doc.html")
        }

        Controls.Button {
            text: qsTr("About Qt")
            onClicked: Qt.openUrlExternally("http://en.wikipedia.org/wiki/Qt_(software)")
        }

        Controls.Button {
            text: qsTr("About the GPL 3.O")
            onClicked: Qt.openUrlExternally("https://www.gnu.org/copyleft/gpl.html")
        }
    }
}
