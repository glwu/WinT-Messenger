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

    signal finishSetup()
    signal openPage(string page)
    signal setBackButtonEnabled(bool enabled)
    signal setTitle(string text)
    signal enableSettingsButton(bool enabled)
    signal enableAboutButton(bool enabled)

    FontLoader {
        source: "qrc:/Fonts/Regular.ttf"
    }

    onClosing: {
        bridge.stopHotspot()
        bridge.stopBtChat()
        bridge.stopNetChat()
    }

    property string defaultFont: "Open Sans"

    Colors {id: colors }
    Sizes  {id: sizes  }

    onFinishSetup: {
        enableAboutButton(true)
        enableSettingsButton(true)
        setBackButtonEnabled(false)

        stackView.clear()
        stackView.push(Qt.resolvedUrl("Pages/Start.qml"))
    }

    onOpenPage             : stackView.push(Qt.resolvedUrl(page))
    onEnableAboutButton    : toolbar.aboutButtonEnabled = enabled
    onEnableSettingsButton : toolbar.settingsButtonEnabled = enabled
    onSetBackButtonEnabled : toolbar.backButtonEnabled = enabled
    onSetTitle             : toolbar.text = text

    Rectangle {
        id: root
        anchors.fill: parent

        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: Loader {
                source: {
                    if (settings.firstLaunch())
                        return "Pages/FirstLaunch.qml"
                    else
                        return "Pages/Start.qml"
                }
            }
        }

        Toolbar {
            id: toolbar
            backButtonOpacity: stackView.depth > 1 ? 1 : 0

            backButtonArea.onClicked: {
                if (!aboutButtonEnabled)
                    enableAboutButton(true)

                if (!settingsButtonEnabled)
                    enableSettingsButton(true)

                stackView.pop()
                bridge.stopNetChat()
            }
        }

        color: colors.background
    }
}
