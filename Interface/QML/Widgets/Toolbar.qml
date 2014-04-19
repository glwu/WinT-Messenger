//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
  property alias text: titleText.text
  property alias settingsButtonEnabled: settingsButton.enabled
  property alias aboutButtonEnabled: aboutButton.enabled

  anchors.left: parent.left
  anchors.right: parent.right
  anchors.top: parent.top

  height: DeviceManager.ratio(56)
  opacity: 0.75
  color: colors.toolbarColorStatic

  Rectangle {
    anchors.fill: parent
    color: colors.toolbarColor
    opacity: 0.7
  }

  Image {
    id: backButton
    anchors.left: parent.left
    anchors.leftMargin: DeviceManager.ratio(4)
    anchors.verticalCenter: parent.verticalCenter
    width: opacity > 0 ? DeviceManager.ratio(48) : 0
    height: DeviceManager.ratio(48)
    asynchronous: true
    source: "qrc:/images/ToolbarIcons/Common/Back.png"
    opacity: stackView.depth > 1 ? 1: 0

    MouseArea {
      id: backButtonMouseArea
      anchors.fill: parent
      onClicked: popStackView()
    }

    Behavior on opacity {NumberAnimation{}}
  }

  Rectangle {
    color: "transparent"
    anchors.right: parent.right
    height: DeviceManager.ratio(48)
    anchors.verticalCenter: parent.verticalCenter
    width: closeButton.width +
           fullscreenButton.width +
           DeviceManager.ratio(12)

    MouseArea {
      id: controlButtonsMouseArea
      anchors.fill: parent
      hoverEnabled: true
    }

    Image {
      id: closeButton
      anchors.right: parent.right
      anchors.rightMargin: DeviceManager.ratio(4)
      anchors.verticalCenter: parent.verticalCenter
      height: DeviceManager.ratio(48)
      opacity: width > 0 ? 1 : 0
      asynchronous: true
      source: "qrc:/images/ToolbarIcons/Common/Close.png"

      width: {
        if (!DeviceManager.isMobile() && fullscreen) {
          if (controlButtonsMouseArea.containsMouse || !settingsButtonEnabled || !aboutButtonEnabled)
            return height;
        }

        return 0;
      }

      MouseArea {
        anchors.fill: parent
        onClicked: close()
      }

      Behavior on width {NumberAnimation{}}
      Behavior on opacity {NumberAnimation{}}
    }

    Image {
      id: fullscreenButton
      anchors.right: closeButton.left
      anchors.rightMargin: DeviceManager.ratio(4)
      anchors.verticalCenter: parent.verticalCenter
      height: DeviceManager.ratio(48)
      opacity: width > 0 ? 1 : 0
      asynchronous: true

      width: {
        if (!DeviceManager.isMobile()) {
          if (controlButtonsMouseArea.containsMouse || !settingsButtonEnabled || !aboutButtonEnabled)
            return height;
        }

        return 0;
      }

      source: !fullscreen ? "qrc:/images/ToolbarIcons/Common/Fullscreen.png" :
                            "qrc:/images/ToolbarIcons/Common/Normal.png"

      MouseArea {
        anchors.fill: parent
        onClicked: toggleFullscreen()
      }

      Behavior on width {NumberAnimation{}}
      Behavior on opacity {NumberAnimation{}}
    }

    Image {
      id: settingsButton
      anchors.right: parent.right
      anchors.rightMargin: closeButton.width + fullscreenButton.width + DeviceManager.ratio(8)
      anchors.verticalCenter: parent.verticalCenter
      height: DeviceManager.ratio(48)
      width: height
      opacity: enabled ? 1 : 0
      source: "qrc:/images/ToolbarIcons/Common/Settings.png"
      asynchronous: true

      MouseArea {
        anchors.fill: parent
        onClicked: openPage("Pages/Preferences.qml")
      }

      Behavior on opacity {NumberAnimation{}}
    }

    Image {
      id: aboutButton
      anchors.right: settingsButton.left
      anchors.rightMargin: DeviceManager.ratio(4)
      anchors.verticalCenter: parent.verticalCenter
      height: DeviceManager.ratio(48)
      width: height
      opacity: enabled ? 1 : 0
      source: "qrc:/images/ToolbarIcons/Common/About.png"
      asynchronous: true

      MouseArea {
        anchors.fill: parent
        onClicked: openPage("Pages/About.qml")
      }

      Behavior on opacity {NumberAnimation{}}
    }
  }

  Label {
    id: titleText
    color: colors.toolbarText
    x: backButton.x + backButton.width + backButton.y
    anchors.verticalCenter: parent.verticalCenter
    font.pixelSize: sizes.toolbarTitle
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    opacity: 0.75

    MouseArea {
      anchors.fill: parent
      onClicked: popStackView()
    }

    Behavior on x {NumberAnimation{easing.type: Easing.OutCubic}}
  }
}
