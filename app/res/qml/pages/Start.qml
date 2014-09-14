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

ColumnPage {
    caption: title
    iconName: "comments"
    title: tr("Welcome")
    subtitle: tr("Please select an option")

    signal chatClicked
    signal newsClicked
    signal helpClicked

    contents: Column {
        spacing: units.scale(4)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -parent.height * 0.17

        Button {
            text: tr("Chat")
            width: units.gu(24)
            onClicked: chatClicked()
        }

        Button {
            text: tr("News")
            width: units.gu(24)
            onClicked: newsClicked()
        }

        Button {
            text: tr("Help")
            width: units.gu(24)
            onClicked: helpClicked()
        }
    }
}
