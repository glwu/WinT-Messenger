//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Controls 1.1
import "Widgets"

ApplicationWindow {
    id: rootWindow
    title: qsTr("WinT Messenger")
    minimumHeight: 480
    minimumWidth: 320

    property string defaultFont: "Open Sans"

    signal finishSetup()
    signal openPage(string page)
    signal setBackButtonEnabled(bool enabled)
    signal setTitle(string text)
    signal enableSettingsButton(bool enabled)
    signal enableAboutButton(bool enabled)

    onFinishSetup: {
        enableAboutButton(true)
        enableSettingsButton(true)
        setBackButtonEnabled(false)

        stackView.clear()
        stackView.push(Qt.resolvedUrl("Pages/Start.qml"))
    }

    onOpenPage: stackView.push(Qt.resolvedUrl(page))
    onEnableAboutButton: toolbar.aboutButtonEnabled = enabled
    onEnableSettingsButton: toolbar.settingsButtonEnabled = enabled
    onSetBackButtonEnabled: toolbar.backButtonEnabled = enabled
    onSetTitle: toolbar.text = text

    onClosing: {
        Bridge.stopHotspot()
        Bridge.stopBtChat()
        Bridge.stopNetChat()
    }

    onXChanged: Settings.setValue("x", x)
    onYChanged: Settings.setValue("y", y)
    onWidthChanged: Settings.setValue("width", width)
    onHeightChanged: Settings.setValue("height", height)

    onWindowStateChanged: {
        x = Settings.value("x", 150)
        y = Settings.value("y", 150)
        width = Settings.value("width", minimumWidth)
        height = Settings.value("height", minimumHeight)

        if (rootWindow.Minimized)
            return;
        if (rootWindow.Maximized)
            Settings.setValue("windowState", "maximized")
        if (rootWindow.FullScreen)
            Settings.setValue("windowState", "fullscreen")
        else
            Settings.setValue("windowState", "normal")
    }

    Component.onCompleted: {
        if (Settings.value("windowState", "normal") === "fullscreen")
            rootWindow.showFullScreen()
        else if (Settings.value("windowState", "normal") === "maximized")
            rootWindow.showMaximized()
        else
            rootWindow.showNormal()
    }

    Colors {id: colors }
    Sizes  {id: sizes  }

    FontLoader {
        id: loader
        source: "qrc:/Fonts/Regular.ttf"
    }

    Rectangle {
        id: root
        anchors.fill: parent

        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: Loader {
                source: {
                    if (Settings.firstLaunch())
                        return "Pages/FirstLaunch.qml"
                    else
                        return "Pages/Start.qml"
                }
            }
        }

        Toolbar {
            id: toolbar
            color: colors.background
            backButtonOpacity: stackView.depth > 1 ? 1: 0

            backButtonArea.onClicked: {
                if (!aboutButtonEnabled)
                    enableAboutButton(true)

                if (!settingsButtonEnabled)
                    enableSettingsButton(true)

                stackView.pop()
                Bridge.stopNetChat()
            }
        }
    }
}
