//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Page {
    // Create the properties
    property alias source: image.source
    property alias text: title.text
    property alias subtitle: sTitle.text
    property int firstItem: sTitle.y + sTitle.height + units.gu(2)

    // Create the bar icon
    rightWidgets:  [
        Button {
            flat: true
            iconName: "bars"
            onClicked: menu.toggle(caller)
            textColor: menu.visible ? theme.getSelectedColor(true) : theme.navigationBarText
        }
    ]

    // Create an item with the logo, title and subtitle
    Item {
        anchors.fill: parent

        // This image is used to display the logo
        Image {
            id: image
            width: height
            asynchronous: true
            height: device.ratio(128)
            source: "qrc:/icons/Logo.svg"
            sourceSize: Qt.size(height, width)
            anchors {
                bottom: title.top
                bottomMargin: units.gu(2)
                horizontalCenter: parent.horizontalCenter
            }
        }

        // This label is used to display the title
        Label {
            id: title
            color: theme.logoTitle
            anchors.centerIn: parent
            font.pixelSize: units.fontSize("x-large")
        }

        // This label is used to display the subtitle
        Label {
            id: sTitle
            color: theme.logoSubtitle
            font.pixelSize: units.fontSize("medium")
            y: title.y + title.height + units.gu(1)
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
