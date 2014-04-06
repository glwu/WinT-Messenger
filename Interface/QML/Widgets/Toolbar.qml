//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Rectangle {
    property bool   backButtonEnabled
    property alias  text: titleText.text

    property alias  backButtonOpacity: backButton.opacity
    property alias  backButtonArea: backMouseArea

    property bool   settingsButtonEnabled: true
    property bool   aboutButtonEnabled: true

    property int buttonSize: bridge.ratio(48)

    height : bridge.ratio(56)

    anchors.left  : parent.left
    anchors.right : parent.right
    anchors.top   : parent.top

    color: colors.toolbarColorStatic
    opacity: settings.opaqueToolbar() ? 1 : 0.7

    Rectangle {
        color: colors.toolbarColor
        anchors.fill: parent
        opacity: 0.97
    }

    Item {
        id: backButton
        anchors.left           : parent.left
        anchors.leftMargin     : bridge.ratio(4)
        anchors.verticalCenter : parent.verticalCenter
        height                 : buttonSize
        width                  : opacity > 0 ? backImage.width : 0

        enabled: parent.backButtonEnabled

        Image {
            id: backImage
            source                   : "qrc:/images/ToolbarIcons/Back.png"
            height                   : buttonSize
            width                    : height
        }

        MouseArea {
            id: backMouseArea
            anchors.fill : parent
        }

        Behavior on opacity { NumberAnimation{} }
    }

    Item {
        id: settingsButton
        anchors.right          : parent.right
        anchors.rightMargin    : bridge.ratio(4)
        anchors.verticalCenter : parent.verticalCenter
        height                 : buttonSize
        width                  : height
        enabled                : settingsButtonEnabled
        opacity                : settingsButtonEnabled ? 1 : 0

        Behavior on opacity { NumberAnimation{} }

        Image {
            id: settingsImage
            anchors.fill: parent
            source: "qrc:/images/ToolbarIcons/Settings.png"
            height: buttonSize
            width : height
        }

        MouseArea {
            id: settingsMouseArea
            anchors.fill : parent
            onClicked: {
                openPage("Pages/Preferences.qml")
                enableSettingsButton(false)
            }
        }
    }

    Item {
        id: aboutButton
        anchors.right          : settingsButton.left
        anchors.rightMargin    : bridge.ratio(4)
        anchors.verticalCenter : parent.verticalCenter
        height                 : buttonSize
        width                  : height
        enabled                : aboutButtonEnabled
        opacity                : aboutButtonEnabled ? 1 : 0

        Behavior on opacity { NumberAnimation{} }
        Behavior on anchors.rightMargin { NumberAnimation{}}

        Image {
            id: aboutImage
            anchors.fill             : parent
            source                   : "qrc:/images/ToolbarIcons/About.png"
            height                   : buttonSize
            width                    : height
        }

        MouseArea {
            id: aboutMouseArea
            anchors.fill : parent
            onClicked: {
                openPage("Pages/About.qml")
                enableAboutButton(false)
            }
        }
    }

    Text {
        id: titleText
        color                    : colors.toolbarText
        x                        : backButton.x + backButton.width + backButton.y
        anchors.verticalCenter   : parent.verticalCenter
        font.pixelSize           : sizes.toolbarTitle
        horizontalAlignment      : Text.AlignHCenter
        verticalAlignment        : Text.AlignVCenter
        font.family              : defaultFont

        MouseArea {
            anchors.fill : parent
            onClicked: stackView.pop()
        }

        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
    }
}

