//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0
import QtQuick.Controls 1.0
import "Widgets"

ApplicationWindow {
    id: rootWindow
    minimumHeight: 480
    minimumWidth : 320
    width: Settings.width()
    color: colors.background
    height: Settings.height()
    title: qsTr("WinT Messenger")
    x: DeviceManager.isMobile() ? 0 : Settings.value("x", 150)
    y: DeviceManager.isMobile() ? 0 : Settings.value("y", 150)

    property string defaultFont: "Open Sans"

    StackView  {id: stackView}
    Colors     {id: colors }
    Sizes      {id: sizes  }
    Toolbar    {id: toolbar}

    Component.onCompleted: Settings.firstLaunch() ? stackView.push("qrc:/QML/Pages/FirstLaunch.qml") :
                                                    stackView.push("qrc:/QML/Pages/Start.qml")

    function popStackView() {
        stackView.pop()

        if (stackView.currentItem.toString() === "qrc:/QML/Pages/Chat.qml") {
            Bridge.stopNetChat()
            Bridge.stopBtChat()
            Bridge.stopHotspot()
        }

        if (!toolbar.controlButtonsEnabled)
            toolbar.controlButtonsEnabled = true
    }

    function openPage(page) {
        stackView.push(page)
    }

    onXChanged: Settings.setValue("x", x)
    onYChanged: Settings.setValue("y", y)
    onWidthChanged: if (!toolbar.fullscreen)  Settings.setValue("width", width)
    onHeightChanged: if (!toolbar.fullscreen) Settings.setValue("height", height)
}
