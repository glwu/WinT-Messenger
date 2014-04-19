//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Item {
  id: page
  anchors.fill: parent

  function setText(text, color) {textbox.text = "<font color=" + color + ">" + text + "</font><br>"}
  property string iconPath
  property bool emotesRectangleEnabled: false
  property bool usersWidgetEnabled: false

  onWidthChanged: {
    if (!usersWidgetEnabled)
      usersPanel.anchors.leftMargin = width
  }

  onHeightChanged: {
    if (!emotesRectangleEnabled)
      emotesPanel.anchors.topMargin = height
  }

  Component.onCompleted: {
    iconPath = Settings.darkInterface() ? "qrc:/images/ToolbarIcons/Light/" : "qrc:/images/ToolbarIcons/Dark/"
    usersPanel.addUser(qsTr("You") + " (" + Settings.value("userName", "unknown") + ")")
  }

  Connections {
    target: Bridge
    onNewUser: usersList.append({"name": nick})
    onDelUser: usersList.remove({"name": nick})
    onNewMessage: {
      textbox.append(text)
      if (textbox.lineCount > textbox.cursorPosition)
        textbox.cursorPosition = textbox.lineCount
    }
  }

  Flickable {
    id: chatWidget
    contentHeight: textbox.paintedHeight
    interactive: true
    flickableDirection: Flickable.VerticalFlick
    anchors.fill: parent
    anchors.bottomMargin: sendRectangle.height + anchors.margins
    clip: true
    anchors.margins: 12

    TextEdit {
      id: textbox
      width: page.width
      anchors.fill: parent
      color: colors.text
      textFormat: TextEdit.RichText
      wrapMode: TextEdit.WordWrap
      renderType: Text.NativeRendering
      font.family: defaultFont
      font.pixelSize: DeviceManager.ratio(14)
      readOnly: true
      clip: true
      onLinkActivated: Qt.openUrlExternally(link)
    }
  }

  Image {
    id: menuButton
    height: width
    width: DeviceManager.ratio(48)
    source: iconPath + "Grid.png"
    asynchronous: true
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: 12

    MouseArea {
      anchors.fill: parent
      onClicked: {
        usersWidgetEnabled = true
        usersPanel.anchors.leftMargin = 0
      }
    }
  }

  Rectangle {
    id: sendRectangle
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: DeviceManager.ratio(32)
    color: "transparent"

    Button {
      id: attachButton
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.top: parent.top
      width: parent.height
      onClicked: Bridge.attachFile()

      Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: width
        width: DeviceManager.ratio(32)
        source: iconPath + "Attach.png"
        asynchronous: true
      }
    }

    Button {
      id: btButton
      anchors.bottom: parent.bottom
      anchors.left: attachButton.right
      anchors.top: parent.top
      anchors.leftMargin: -1
      width: visible ? parent.height : 0
      onClicked: Bridge.showBtSelector()
      enabled: Bridge.btChatEnabled()
      visible: enabled

      Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: width
        width: parent.visible ? DeviceManager.ratio(32) : 0
        source: iconPath + "Bluetooth.png"
        asynchronous: true
      }
    }

    Textbox {
      id: sendTextbox
      anchors.left: btButton.right
      anchors.right: emotesButton.left
      anchors.bottom: parent.bottom
      anchors.top: parent.top
      anchors.rightMargin: -1
      anchors.leftMargin: -1
      placeholderText: qsTr("Type a message...")
      Keys.onReturnPressed: {
        if (text.length > 0) {
          Bridge.sendMessage(sendTextbox.text)
          sendTextbox.text = ""
        }
      }
    }

    Button {
      id: emotesButton
      anchors.right: sendButton.left
      anchors.bottom: parent.bottom
      anchors.top: parent.top
      width: parent.height
      anchors.rightMargin: -1

      Image {
        height: width
        width: DeviceManager.ratio(16)
        source: "qrc:/emotes/smile.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        enabled: parent.enabled
      }

      onClicked: {
        enabled = false
        emotesRectangleEnabled = true
        emotesPanel.anchors.topMargin = page.height / 2
      }
    }

    Button {
      id: sendButton
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.top: parent.top
      width: DeviceManager.ratio(64)
      text: qsTr("Send")
      enabled: sendTextbox.length > 0 ? 1: 0
      onClicked: {
        Bridge.sendMessage(sendTextbox.text)
        sendTextbox.text = ""
      }
    }
  }

  Emotes {id: emotesPanel}
  Users {id: usersPanel}

}
