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

Dialog {
    id: _help
    title: tr("Get Help")

    signal bugClicked
    signal docClicked
    signal supportClicked

    contents: Item {
        id: item
        anchors.centerIn: parent

        Label {
            id: _caption
            text: tr("Help")
            fontSize: "xx-large"
            color: theme.logoTitle
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -units.scale(12)
        }

        Label {
            id: _subtitle
            fontSize: "medium"
            color: theme.logoSubtitle
            anchors.top: _caption.bottom
            anchors.margins: units.scale(6)
            centered: true
            text: tr("Here are a few options to get support")
        }

        Icon {
            name: "help"
            width: height
            iconSize: height
            color: theme.iconColor
            height: units.scale(96)
            anchors.bottom: _caption.top
            anchors.margins: units.scale(12)
            centered: true
        }

        Column {
            spacing: units.scale(4)

            anchors {
                top: _subtitle.bottom
                bottom: parent.bottom
                margins: units.scale(12)
                horizontalCenter: item.horizontalCenter
            }

            anchors.verticalCenterOffset: -parent.height * 0.17

            Button {
                text: tr("Report bug")
                onClicked: bugClicked()
                width: units.gu(24)
            }

            Button {
                width: units.gu(24)
                text: tr("Direct support")
                onClicked: supportClicked()
            }

            Button {
                onClicked: docClicked()
                width: units.gu(24)
                text: tr("Documentation")
            }
        }
    }
}
