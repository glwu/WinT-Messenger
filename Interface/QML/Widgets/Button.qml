//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0

Rectangle {
    id: button
    implicitHeight : smartBorderSize(32)
    implicitWidth  : smartBorderSize(192)

    signal clicked
    property alias text: label.text

    opacity: 0.75

    color: {
        if (mouseArea.pressed)
            return "#c7dfe8"
        else
            return "#f1f1f1"
    }

    border.color: {
        if (mouseArea.pressed || mouseArea.containsMouse)
            return "#33b6e6"
        else
            return "#9f9f9f"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked   : button.clicked()
    }

    Text {
        id: label
        anchors.centerIn: parent
        font.pixelSize  : smartFontSize(12)
        font.family     : defaultFont
        color           : parent.enabled ? "#222" : "#aaa"
        antialiasing    : true
    }
}
