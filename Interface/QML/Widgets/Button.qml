//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2

Rectangle {
    id: button
    height : smartBorderSize(32)
    width  : smartBorderSize(192)

    signal clicked
    property alias text: label.text

    opacity: 0.75
    color: "#f1f1f1"

    border.color: {
        if (mouseArea.pressed || mouseArea.containsMouse)
            return settings.value("userColor", "#55aa7f")
        else
            return colors.border
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
    }
}
