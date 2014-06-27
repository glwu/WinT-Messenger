//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Controls 1.1 as Controls
import "controls"

PageApplication {
    id: app
    title: "WinT Messenger"

    x: settings.x()
    y: settings.y()
    width: settings.width()
    height: settings.height()

    onXChanged: settings.setValue("x", x)
    onYChanged: settings.setValue("y", y)
    onWidthChanged: settings.setValue("width", width)
    onHeightChanged: settings.setValue("height", height)

    minimumWidth: units.gu(40)
    minimumHeight: units.gu(60)

    initialPage: start

    Component.onCompleted: {
        if (settings.firstLaunch())
            preferencesSheet.open()
    }

    Connections {
        target: bridge
        onUpdateAvailable: notification.show("A new version of WinT Messenger is available!")
    }

    Chat {
        id: chat
    }

    Logo {
        id: start
        text: qsTr("Welcome")
        title: qsTr("Welcome")
        source: "qrc:/icons/Logo.svg"
        subtitle: qsTr("Please choose an option")

        Column {
            y: start.firstItem
            spacing: units.gu(0.5)
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: qsTr("Chat")
                width: units.gu(24)
                onClicked: app.push(chat)
            }

            Button {
                text: qsTr("News")
                width: units.gu(24)
                onClicked: Qt.openUrlExternally("http://wint-im.sf.net#news")
            }

            Button {
                text: qsTr("Help")
                width: units.gu(24)
                onClicked: app.push(help)
            }
        }
    }

    Logo {
        id: help
        text: qsTr("Help")
        title: qsTr("Get Help")
        source: "qrc:/icons/Help.svg"
        subtitle: qsTr("Need help? Find it here!")

        Column {
            y: help.firstItem
            spacing: units.gu(0.5)
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                width: units.gu(24)
                text: qsTr("About Qt")
                onClicked: Qt.openUrlExternally("http://en.wikipedia.org/wiki/Qt_(software)")
            }

            Button {
                width: units.gu(24)
                text: qsTr("Documentation")
                onClicked: Qt.openUrlExternally("http://wint-im.sf.net/doc/doc.html")
            }

            Button {
                width: units.gu(24)
                text: qsTr("Dev's documentation")
                onClicked: Qt.openUrlExternally("http://wint-im.sf.net/dev-doc/html/index.html")
            }
        }
    }

    AboutSheet {
        id: aboutSheet
        version: "1.3.0"
        author: "Alex Spataru"
        appName: "WinT Messenger"
        icon: "qrc:/icons/Logo.svg"
        website: "http://wint-im.sf.net"
        contactEmail: "alex.racotta@gmail.com"
        appMotto: "Simple and lightweight IM client"
        copyright: "Copyright (C) 2014 the WinT 3794 team"
        reportABug: "https://github.com/WinT-3794/WinT-Messenger/issues/new"
    }
}
