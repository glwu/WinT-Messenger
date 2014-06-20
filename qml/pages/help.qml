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

    // Create a column with option buttons
    Column {
        y: arrangeFirstItem
        spacing: device.ratio(4)
        anchors.horizontalCenter: parent.horizontalCenter

        // Open the user documentation
        Controls.Button {
            text: qsTr("Documentation")
            onClicked: Qt.openUrlExternally(
                           "http://wint-im.sf.net/doc/doc.html")
        }

        // Open the developer documentation
        Controls.Button {
            text: qsTr("Developer documentation")
            onClicked: Qt.openUrlExternally(
                           "http://wint-im.sf.net/dev-doc/html/" +
                           "index.html")
        }

        // Open the GPL 3.0 web page
        Controls.Button {
            text: qsTr("About the GPL 3.O")
            onClicked: Qt.openUrlExternally(
                           "https://www.gnu.org/copyleft/gpl.html")
        }
    }
}
