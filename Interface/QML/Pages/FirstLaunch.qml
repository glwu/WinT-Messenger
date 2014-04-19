//
//  This file is part of the WinT Messenger
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.0
import QtQuick.Controls 1.0
import "../Widgets"

Page {
  logoImageSource: "qrc:/images/Logo.png"
  logoSubtitle: qsTr("Customize your setup")
  logoTitle: qsTr("Initial setup")
  toolbarTitle: qsTr("Initial setup")

  Component.onCompleted: {
    toolbar.aboutButtonEnabled = false
    toolbar.settingsButtonEnabled = false
  }

  Column {
    spacing: DeviceManager.ratio(8)
    y: arrangeFirstItem
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 24
    anchors.rightMargin: 24

    Rectangle {
      anchors.left: parent.left
      anchors.right: parent.right
      height: textBox.height

      color: "transparent"

      Textbox {
        id: textBox
        anchors.left: parent.left
        anchors.right: colorRectangle.left
        anchors.rightMargin: 2
        placeholderText: qsTr("Type a nickname and choose a profile color")
        Keys.onReturnPressed: {
          if (text.length > 0) {
            Settings.setValue("userName", textBox.text)
            Settings.setValue("userColor", colors.userColor)
            Settings.setValue("firstLaunch", false);
            Settings.setValue("customizedUiColor", customizedUiColor.checked)

            colors.userColor = colors.userColor

            finishSetup(textBox.text)
            Qt.inputMethod.hide()
          }
        }
      }

      Rectangle {
        id: colorRectangle
        anchors.right: parent.right
        height: textBox.height
        width: height
        border.width: 1
        color: colors.userColor
        border.color: {
          if (mouseArea.containsMouse)
            return colors.borderColor
          else if (mouseArea.pressed)
            return colors.borderColor
          else
            return colors.borderColor
        }

        onColorChanged: {
          Settings.setValue("userColor", colors.userColor)
          colors.userColor = colors.userColor

          if (Settings.customizedUiColor())
            colors.toolbarColor = colors.userColor
          else
            colors.toolbarColor = colors.toolbarColorStatic
        }

        MouseArea {
          id: mouseArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: colors.userColor = Settings.getDialogColor(colors.userColor)
        }
      }
    }

    CheckBox {
      id: darkInterface
      checked: Settings.darkInterface()
      onCheckedChanged: {Settings.setValue("darkInterface", checked); colors.setColors();}

      Label {
        anchors.left: darkInterface.right
        text: qsTr("Use a dark interface")
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: sizes.control
      }
    }

    CheckBox {
      id: customizedUiColor
      checked: Settings.customizedUiColor()
      onCheckedChanged: {
        Settings.setValue("customizedUiColor", checked)

        if (Settings.customizedUiColor())
          colors.toolbarColor = colors.userColor
        else
          colors.toolbarColor = colors.toolbarColorStatic
      }

      Label {
        anchors.left: customizedUiColor.right
        text: qsTr("Use the profile color to theme the app")
        anchors.verticalCenter: parent.verticalCenter
      }
    }
  }

  Button {
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 10 + parent.height / 16
    anchors.horizontalCenter: parent.horizontalCenter
    text: qsTr("Done")
    enabled: textBox.length > 0 ? 1: 0
    onClicked: {
      Settings.setValue("userName", textBox.text)
      Settings.setValue("userColor", colors.userColor)
      Settings.setValue("firstLaunch", false);
      Settings.setValue("customizedUiColor", customizedUiColor.checked)
      Settings.setValue("darkInterface", darkInterface.checked)

      finishSetup(textBox.text)
      Qt.inputMethod.hide()
    }
  }
}
