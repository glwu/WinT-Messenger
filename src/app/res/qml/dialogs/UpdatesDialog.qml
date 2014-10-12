//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import QtQuick 2.0
import "../controls"

MessageBox {
    id: _updates
    icon: "refresh"
    title: qsTr("Check for updates")

    property bool updates_available
    property bool notify_updates

    Connections {
        target: bridge
        onUpdateAvailable: {
            if (notify_updates)
                updatesAvailable()
        }
    }

    Component.onCompleted: {
        if (settings.notifyUpdates())
            checkForUpdates(true)
    }

    function checkForUpdates(notify) {
        notify_updates = notify
        bridge.checkForUpdates()
    }

    function updatesAvailable() {
        _updates.updates_available = true
        _updates.caption = qsTr("A new version of WinT Messenger is available to download")
        _updates.details = qsTr("Would you like to open a web browser to download it?")

        _updates.open()
    }

    function latestVersion() {
        _updates.updates_available = false
        _updates.caption = qsTr("There are no updates available")
        _updates.details = qsTr("You are running the latest version of WinT Messenger")

        _updates.open()
    }

    data: Item {
        property int da_button_width: {
            return _yes_button.width > _no_button.width ?
                        _yes_button.width : _no_button.width
        }

        Button {
            id: _yes_button
            anchors.centerIn: parent
            anchors.verticalCenterOffset: units.gu(3)
            text: _updates.updates_available ? qsTr("Yes, download the new version") : qsTr("Close")
            onClicked: _updates.updates_available ? Qt.openUrlExternally("http://wint-im.sf.net") :
                                                    _updates.close()

            Component.onCompleted: {
                width = parent.da_button_width
            }
        }

        Button {
            id: _no_button
            visible: updates_available
            y: _yes_button.y + height + units.gu(1)
            text: qsTr("No (and don't remind me again)")
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                _updates.close()
                settings.setValue("notifyUpdates", false)
            }

            Component.onCompleted: {
                width = parent.da_button_width
            }
        }
    }
}
