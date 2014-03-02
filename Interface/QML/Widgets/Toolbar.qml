//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//
import QtQuick 2.0


Rectangle {
    property bool   backButtonEnabled
    property alias  text: windowTitleText.text
    property alias  backButtonOpacity: backButton.opacity
    property alias  backButtonArea: backMouseArea
    property bool   settingsButtonEnabled: true
    property bool   aboutButtonEnabled: true

    height : backButton.height * 1.25

    anchors.left  : parent.left
    anchors.right : parent.right
    anchors.top   : parent.top

    color: colors.toolbarColor

    MouseArea {
        anchors.fill: parent
        property variant clickPos: "1,1"

        onPressed: {
            clickPos  = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            rootWindow.x = rootWindow.x+delta.x;
            rootWindow.y = rootWindow.y+delta.y;
        }

        enabled: !isMobile
    }

    Rectangle {
        id: backButton
        anchors.left           : parent.left
        anchors.leftMargin     : 4
        anchors.verticalCenter : parent.verticalCenter
        color                  : "transparent"
        height                 : backImage.height
        width                  : opacity > 0 ? backImage.width : 0

        enabled: parent.backButtonEnabled

        radius: 4
        antialiasing: true

        Image {
            id: backImage
            smooth                   : true
            source                   : "qrc:/images/ToolbarIcons/Back.png"
            height                   : 48
            width                    : 48
            antialiasing             : true
        }

        MouseArea {
            id: backMouseArea
            anchors.fill : parent
        }

        Behavior on opacity { NumberAnimation{} }
    }

    Rectangle {
        id: settingsButton
        anchors.right          : /*isMobile ? parent.right : separator.left*/ parent.right
        anchors.rightMargin    : 4
        anchors.verticalCenter : parent.verticalCenter
        color                  : "transparent"
        height                 : settingsImage.height
        width                  : settingsImage.width
        enabled                : settingsButtonEnabled
        opacity                : settingsButtonEnabled ? 1 : 0

        Behavior on opacity { NumberAnimation{} }

        Image {
            id: settingsImage
            anchors.fill             : parent
            smooth                   : true
            source                   : "qrc:/images/ToolbarIcons/Settings.png"
            antialiasing             : true
            height                   : 48
            width                    : 48
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

    Rectangle {
        id: aboutButton
        anchors.right: parent.right
        anchors.rightMargin: settingsButton.opacity > 0 ? 2 * settingsButton.anchors.rightMargin + settingsButton.width :
                                                          4
        anchors.verticalCenter : parent.verticalCenter
        color                  : "transparent"
        height                 : aboutImage.height
        width                  : aboutImage.width
        enabled                : aboutButtonEnabled
        opacity                : aboutButtonEnabled ? 1 : 0

        Behavior on opacity { NumberAnimation{} }
        Behavior on anchors.rightMargin { NumberAnimation{}}

        Image {
            id: aboutImage
            anchors.fill             : parent
            source                   : "qrc:/images/ToolbarIcons/About.png"
            antialiasing             : true
            height                   : 48
            width                    : 48
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
        id: windowTitleText
        color                    : colors.toolbarText
        x                        : backButton.x + backButton.width + backButton.y
        anchors.verticalCenter   : parent.verticalCenter
        font.pixelSize           : smartFontSize(20)
        horizontalAlignment      : Text.AlignHCenter
        verticalAlignment        : Text.AlignVCenter
        font.family              : defaultFont

        MouseArea {
            anchors.fill : parent
            onClicked: {
                if (isMobile)
                    stackView.pop()
            }
        }

        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
    }
}

