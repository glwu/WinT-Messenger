//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"

import QtQuick 2.0

MessageBox {
    icon: "about"
    caption: tr(appName)
    title: tr("About") + " " + tr(appName)
    details: tr("Version") + " " + appVersion

    data: Item {
        Button {
            id: _check4updates
            anchors.centerIn: parent
            width: _acknowledgements.width
            text: tr("Check for updates")
            onClicked: {
                close()
                updates.checkForUpdates(true)
            }
        }

        Button {
            id: _acknowledgements
            text: tr("Acknowledgements")
            anchors.topMargin: units.gu(0.5)
            anchors.top: _check4updates.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                close()
                Qt.openUrlExternally("http://wint-im.sf.net/acknowledgements")
            }
        }

        Label {
            centered: true
            textFormat: Text.RichText
            anchors.topMargin: units.gu(2)
            anchors.top: _acknowledgements.bottom
            text: tr("Copyright") + " &copy; 2013-" +
                  Qt.formatDateTime(new Date(), "yyyy ") + appCompany
        }
    }
}
