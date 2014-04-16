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
    Colors  {id: colors }
    Sizes   {id: sizes  }

    id: rootWindow
    title: qsTr("WinT Messenger")

    minimumHeight: 480
    minimumWidth: 320

    color: colors.background

    Component.onCompleted: {
        colors.setColors()
        x = Settings.value("x", 150)
        y = Settings.value("y", 150)
        width = Settings.value("width", minimumWidth)
        height = Settings.value("height", minimumHeight)
   }

    property string defaultFont: "Open Sans"
    property bool fullscreen: Settings.fullscreen()

    function toggleFullscreen() {
        if (fullscreen) {
            showNormal()
            fullscreen = false
            return;
       }

        showFullScreen()
        fullscreen = true
   }

    function finishSetup() {
        toolbar.aboutButtonEnabled = true
        toolbar.settingsButtonEnabled = true
        stackView.clear()
        stackView.push(Qt.resolvedUrl("Pages/Start.qml"))
   }

    function popStackView() {
        stackView.pop()
        Bridge.stopNetChat()
        Bridge.stopBtChat()
        Bridge.stopHotspot()

        if (!toolbar.aboutButtonEnabled || !toolbar.settingsButtonEnabled) {
            toolbar.aboutButtonEnabled = true
            toolbar.settingsButtonEnabled = true
       }
   }

    function openPage(page) {
        stackView.push(Qt.resolvedUrl(page))
   }

    onClosing: {
        Bridge.stopHotspot()
        Bridge.stopBtChat()
        Bridge.stopNetChat()
        Settings.setValue("fullscreen", fullscreen)
   }

    onXChanged: Settings.setValue("x", x)
    onYChanged: Settings.setValue("y", y)
    onWidthChanged: Settings.setValue("width", width)
    onHeightChanged: Settings.setValue("height", height)

    FontLoader {
        id: loader
        source: "qrc:/Fonts/Regular.ttf"
   }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: Loader {source: Settings.firstLaunch() ? "Pages/FirstLaunch.qml" : "Pages/Start.qml";}
   }

    Toolbar {id: toolbar}
}
