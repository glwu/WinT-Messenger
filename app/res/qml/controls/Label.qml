//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import QtQuick 2.3

Text {
    property bool centered: false
    property string style: "default"
    property string fontSize: "small"

    smooth: true
    font.family: global.font
    textFormat: Text.PlainText
    font.pixelSize: units.size(fontSize)
    linkColor: Qt.darker(theme.primary, 1.2)
    onLinkActivated: Qt.openUrlExternally(link)
    anchors.horizontalCenter: centered ? parent.horizontalCenter : undefined
    color: style === "default" ? theme.textColor : theme.getStyleColor(style)
}
