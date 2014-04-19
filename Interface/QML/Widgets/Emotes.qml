//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
  id: emotesPanel
  anchors.fill: parent
  anchors.topMargin: parent.height
  anchors.bottomMargin: sendRectangle.height

  opacity: emotesPanel.anchors.topMargin < pageHeight ? 1 : 0
  enabled: emotesRectangleEnabled

  Behavior on opacity {NumberAnimation{}}
  Behavior on anchors.topMargin {NumberAnimation{}}

  property int pageHeight: parent.height

  GridView {
    anchors.fill: parent
    anchors.topMargin: emotesCaptionRectangle.y + emotesCaptionRectangle.height + anchors.margins
    anchors.margins: 12

    cellHeight: DeviceManager.ratio(36)
    cellWidth: cellHeight

    model: emotesModel
    delegate: Rectangle {
      height: DeviceManager.ratio(32)
      width: height
      color: emotesMouseArea.containsMouse ? colors.toolbarColorStatic : "transparent"

      Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: width
        width: DeviceManager.ratio(16)
        source: "qrc:/emotes/" + name + ".png"
        asynchronous: true
      }

      MouseArea {
        id: emotesMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: sendTextbox.text = sendTextbox.text + "*" + name + "*"
      }
    }

    ListModel {
      id: emotesModel
      ListElement {name: "alien"}
      ListElement {name: "angry"}
      ListElement {name: "angel"}
      ListElement {name: "cool"}
      ListElement {name: "crying"}
      ListElement {name: "devil"}
      ListElement {name: "grin"}
      ListElement {name: "heart"}
      ListElement {name: "joyful"}
      ListElement {name: "kissing"}
      ListElement {name: "lol"}
      ListElement {name: "angry"}
      ListElement {name: "pouty"}
      ListElement {name: "sad"}
      ListElement {name: "sick"}
      ListElement {name: "angry"}
      ListElement {name: "sleeping"}
      ListElement {name: "smile"}
      ListElement {name: "pinched"}
      ListElement {name: "tongue"}
      ListElement {name: "uncertain"}
      ListElement {name: "grin"}
      ListElement {name: "wink"}
      ListElement {name: "wondering"}
    }
  }

  Rectangle {
    id: emotesCaptionRectangle
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    height: toolbar.height
    color: colors.toolbarColorStatic
    opacity: toolbar.opacity

    Label {
      anchors.left: parent.left
      anchors.margins: 12
      anchors.verticalCenter: parent.verticalCenter

      font.pixelSize: sizes.toolbarTitle
      text: qsTr("Emotes")
      color: colors.toolbarText
      height: DeviceManager.ratio(48)
      verticalAlignment: Text.AlignVCenter
    }

    Image {
      id: emotesCloseButton
      anchors.right: parent.right
      anchors.margins: 12
      anchors.verticalCenter: parent.verticalCenter

      source: "qrc:/images/ToolbarIcons/Common/Close.png"
      height: DeviceManager.ratio(48)
      width: height
      rotation: 180
      asynchronous: true
      opacity: emotesPanel.opacity
      enabled: emotesPanel.enabled

      Behavior on opacity {NumberAnimation{}}

      MouseArea {
        anchors.fill: parent
        onClicked: {
          emotesButton.enabled = true
          emotesPanel.anchors.topMargin = pageHeight
          emotesRectangleEnabled = false
        }
      }
    }
  }
}
