//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.3

Rectangle {
    smooth: true
    opacity: 0.85
    color: "#ec3e3a"
    radius: width / 2
    height: units.scale(18)
    width: label.text.length > 2 ? label.paintedWidth + height / 2 : height

    property alias text: label.text

    anchors {
        right: parent.right
        bottom: parent.bottom
        margins: -parent.width / 5 + units.scale(1)
    }

    Label {
        id: label
        color: "#fdfdfdfd"
        anchors.fill: parent
        font.pixelSize: units.scale(9)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.margins: -parent.width / 5 + units.scale(1)
    }
}
