//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "."
import "../dialogs"
import "../controls"

import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.0 as Controls

Window {
    id: _app
    color: theme.background

    property alias app: _app
    property alias units: _units
    property alias theme: _theme
    property alias stack: _stack
    property alias global: _global
    property alias updates: _updates
    property alias overlay: _overlay
    property alias appMenu: _app_menu
    property alias navigationBar: _navBar
    property alias avatarMenu: _avatarMenu
    property alias notification: _notification
    property bool  mobileDevice: device.isMobile()

    property Page initialPage

    function tr(string) {
        return qsTr(string)
    }

    QtObject {
        id: _units

        function scale(number) {
            return device.ratio(number)
        }

        function gu(number) {
            return units.scale(8 * number)
        }

        function size(string) {
            if (string === "xx-large")     return gu(2.7)
            else if (string === "x-large") return gu(2.4)
            else if (string === "large")   return gu(2.2)
            else if (string === "medium")  return gu(1.9)
            else if (string === "small")   return gu(1.6)
            else if (string === "x-small") return gu(1.2)
            else {
                console.log("Warning: " + string + " is not a valid size!")
                return gu(1.6)
            }
        }
    }

    Theme {
        id: _theme
    }

    QtObject {
        id: _global
        property string font: "Roboto"
        property var roboto_loader: FontLoader {
            source: "qrc:/fonts/fonts/regular.ttf"
        }
        property var awesome_loader: FontLoader {
            source: "qrc:/fonts/fonts/font_awesome.ttf"
        }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: appMenu.close()
    }

    Controls.StackView {
        id: _stack
        anchors.fill: parent
        initialItem: initialPage
        anchors.topMargin: _navBar.height
    }

    NavigationBar {
        id: _navBar
    }

    Rectangle {
        opacity: 0
        id: _overlay
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.4)
        Behavior on opacity {NumberAnimation{}}

        signal opened()
        property int openDialogs: 0

        function open() {
            opacity =  1
            openDialogs += 1
            opened()
        }

        function close() {
            openDialogs -= 1

            if (openDialogs == 0)
                opacity = 0
        }

        MouseArea {
            anchors.fill: parent
            enabled: parent.opacity > 0
        }
    }

    AboutDialog {
        id: _about_dialog
    }

    Preferences {
        id: _preferences
    }

    MessageBox {
        icon: "bitcoin"
        id: _donate_bitcoins
        title: tr("Donate Bitcoins")
        caption: tr("Donate Bitcoins")
        details: tr("You can donate BitCoins to the following address")

        data: Column {
            spacing: units.gu(1)
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                id: _address
                color: theme.success
                anchors.left: parent.left
                anchors.right: parent.right
                font.pixelSize: units.size("small")
                text: "3C8VJ37dyxfLzKfPXrbbgYMerDa1tzNGVe"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }

            Button {
                text: tr("Copy address to clipboard")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    bridge.copy(_address.text)
                    notification.show(tr("Bitcoin address copied successfully!"))
                }
            }

            Button {
                text: tr("Learn more about Bitcoin")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    _donate_bitcoins.close()
                    Qt.openUrlExternally("https://bitcoin.org")
                }
            }

        }
    }

    MessageBox {
        id: _updates
        icon: "refresh"
        title: tr("Check for updates")

        property bool updates_available

        function checkForUpdates(notify) {
            if (bridge.checkForUpdates())
                updatesAvailable()
            else if (notify)
                latestVersion()
        }

        function updatesAvailable() {
            _updates.updates_available = true
            _updates.caption = tr("There are updates available")
            _updates.details = tr("Do you want to open a browser to download them?")

            _updates.open()
        }

        function latestVersion() {
            _updates.updates_available = false
            _updates.caption = tr("There are no updates available")
            _updates.details = tr("You are running the latest version of WinT Messenger")

            _updates.open()
        }

        data: Item {
            Button {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: units.gu(3)
                text: _updates.updates_available ? tr("Download Updates") : tr("Close")
                onClicked: _updates.updates_available ? Qt.openUrlExternally("http://wint-im.sf.net") :
                                                        _updates.close()
            }
        }
    }

    Menu {
        id: _app_menu

        data: Column {
            anchors.centerIn: parent

            Button {
                flat: true
                iconName: "about"
                text: tr("About")
                fontSize: "medium"
                width: website.width
                onClicked: _about_dialog.open()
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                flat: true
                iconName: "cog"
                fontSize: "medium"
                width: website.width
                text: tr("Preferences")
                onClicked: _preferences.open()
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                flat: true
                id: donate
                fontSize: "medium"
                iconName: "bitcoin"
                width: website.width
                text: tr("Donate Bitcoins")
                onClicked: _donate_bitcoins.open()
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                flat: true
                id: website
                iconName: "globe"
                fontSize: "medium"
                text: tr("WinT 3794 Website")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: Qt.openUrlExternally("http://wint3794.org")
            }
        }
    }

    Menu {
        id: _avatarMenu

        height: width * 0.8
        width: app.width < app.height ? app.width * 0.9 : units.gu(32)

        signal updateAvatarImage(string image)

        data: Controls.ScrollView {
            anchors.fill: parent
            anchors.centerIn: parent

            GridView {
                model: facesList
                anchors.fill: parent

                cellWidth: units.scale(56)
                cellHeight: units.scale(56)

                delegate: Rectangle {
                    width: height
                    color: "transparent"
                    height: units.scale(52)

                    Rectangle {
                        color: "#49759C"
                        anchors.fill: parent
                        opacity: avatarMouseArea.containsMouse ? 1 : 0
                    }

                    Image {
                        height: width
                        asynchronous: true
                        width: units.scale(48)
                        anchors.centerIn: parent
                        source: "qrc:/faces/faces/" + modelData
                    }

                    MouseArea {
                        id: avatarMouseArea
                        anchors.fill: parent
                        hoverEnabled: !app.mobileDevice
                        onClicked: {
                            avatarMenu.toggle()
                            settings.setValue("face", modelData)
                            avatarMenu.updateAvatarImage(modelData)
                        }
                    }
                }
            }
        }
    }

    Notification {
        id: _notification
    }
}
