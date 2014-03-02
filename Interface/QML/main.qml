//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Particles 2.0
import "Widgets"

ApplicationWindow {
    id: rootWindow
    title: qsTr("WinT Messenger")

    minimumHeight: 480
    minimumWidth: 320

    signal finishSetup(string username)
    signal openPage(string page)
    signal setBackButtonEnabled(bool enabled)
    signal setTitle(string text)
    signal enableSettingsButton(bool enabled)
    signal enableAboutButton(bool enabled)

    FontLoader {
        source: "qrc:/Interface/Resources/Fonts/Regular.ttf"
    }

    property string defaultFont: "Roboto"
    property string controlPath: "qrc:/images/Controls/"

    function smartFontSize(integer) {
        if (settings.value("mobileOptimized", isMobile) === true)
            return integer * 1.25
        else
            return integer
    }

    function smartBorderSize(integer) {
        if (settings.value("mobileOptimized", isMobile) === true)
            return integer * 1.25
        else
            return integer
    }

    Colors {id: colors}

    onFinishSetup: {
        stackView.clear()
        stackView.push(Qt.resolvedUrl("Pages/Start.qml"))
        enableSettingsButton(false)
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
                    if (settings.value("firstLaunch", true) === true)
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
                if (aboutButtonEnabled == false)
                    enableAboutButton(true)

                if (settingsButtonEnabled == false)
                    enableSettingsButton(true)

                stackView.pop()
                bridge.stopLanChat()
            }
        }

        color: colors.background
    }
}
