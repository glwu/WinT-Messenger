//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2

Rectangle {
    property bool   backButtonEnabled
    property alias  text: titleText.text

    property alias  backButtonOpacity: backButton.opacity
    property alias  backButtonArea: backMouseArea

    property bool   settingsButtonEnabled: true
    property bool   aboutButtonEnabled: true

    height : isMobile ? smartSize(32) : smartSize(28)

    anchors.left  : parent.left
    anchors.right : parent.right
    anchors.top   : parent.top

    color: "#3c3b37"

    Rectangle {
        color: colors.userColor
        anchors.fill: parent
        opacity: 0.5
    }

    Item {
        id: backButton
        anchors.left           : parent.left
        anchors.leftMargin     : smartSize(4)
        anchors.verticalCenter : parent.verticalCenter
        height                 : smartSize(24)
        width                  : opacity > 0 ? backImage.width : 0

        enabled: parent.backButtonEnabled

        Image {
            id: backImage
            source                   : "qrc:/images/ToolbarIcons/Back.png"
            height                   : smartSize(24)
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
        anchors.rightMargin    : smartSize(4)
        anchors.verticalCenter : parent.verticalCenter
        height                 : smartSize(24)
        width                  : height
        enabled                : settingsButtonEnabled
        opacity                : settingsButtonEnabled ? 1 : 0

        Behavior on opacity { NumberAnimation{} }

        Image {
            id: settingsImage
            anchors.fill: parent
            source: "qrc:/images/ToolbarIcons/Settings.png"
            height: smartSize(24)
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
        anchors.rightMargin    : smartSize(4)
        anchors.verticalCenter : parent.verticalCenter
        height                 : smartSize(24)
        width                  : height
        enabled                : aboutButtonEnabled
        opacity                : aboutButtonEnabled ? 1 : 0

        Behavior on opacity { NumberAnimation{} }
        Behavior on anchors.rightMargin { NumberAnimation{}}

        Image {
            id: aboutImage
            anchors.fill             : parent
            source                   : "qrc:/images/ToolbarIcons/About.png"
            height                   : smartSize(24)
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
        font.pointSize           : isMobile ? 24 : 18
        horizontalAlignment      : Text.AlignHCenter
        verticalAlignment        : Text.AlignVCenter
        font.family              : defaultFont

        opacity: 0.75

        MouseArea {
            anchors.fill : parent
            onClicked: stackView.pop()
        }

        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
    }
}

