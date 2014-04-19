//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Rectangle {
  id: panel
  anchors.fill: parent
  anchors.leftMargin: masterWidth

  opacity: anchors.leftMargin < masterWidth ? 1 : 0
  enabled: usersWidgetEnabled

  Behavior on opacity {NumberAnimation{}}
  Behavior on anchors.leftMargin {NumberAnimation{}}
  ListModel {id: usersList}

  property int masterWidth: parent.width

  function addUser(name) {
      usersList.append({"name": name})
  }

  Connections {
    target: Bridge
    onNewUser: usersList.append({"name": nick})
    onDelUser: usersList.remove({"name": nick})
  }

  GridView {
    id: usersGrid
    anchors.fill: parent
    anchors.topMargin: captionRectangle.y + captionRectangle.height + anchors.margins
    anchors.margins: 12

    cellHeight: DeviceManager.ratio(72)
    cellWidth: DeviceManager.ratio(256)

    visible: panel.anchors.leftMargin === 0 ? 1 : 0

    model: usersList
    delegate: Rectangle {
      color: mouseArea.containsMouse ? colors.toolbarColorStatic: "transparent"
      height: usersGrid.cellHeight
      width: usersGrid.cellWidth

      Connections {
        target: Bridge
        onDelUser:  {
          if (nick == label.text)
            destroy();
        }
      }

      Image {
        id: userPicture
        height: width
        width: DeviceManager.ratio(64)
        source: "qrc:/images/ToolbarIcons/Common/Person.png"
        asynchronous: true
        anchors.left: parent.left
        anchors.margins: DeviceManager.ratio(4)
        anchors.verticalCenter: parent.verticalCenter
      }

      Label {
        id: label
        text: name
        color: colors.toolbarText
        anchors.left: userPicture.right
        anchors.right: parent.right
        anchors.margins: DeviceManager.ratio(4)
        anchors.verticalCenter: parent.verticalCenter
      }

      MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
      }
    }
  }

  Rectangle {
    id: captionRectangle
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    height: toolbar.height
    color: colors.toolbarColorStatic
    opacity: toolbar.opacity

    Label {
      id: userWidgetTitle
      font.pixelSize: sizes.toolbarTitle
      text: qsTr("Users")
      color: colors.toolbarText
      anchors.left: parent.left
      anchors.margins: 12
      anchors.verticalCenter: parent.verticalCenter
      height: DeviceManager.ratio(48)
      verticalAlignment: Text.AlignVCenter
      opacity: 0.75
    }

    Image {
      id: closeButton
      anchors.right: parent.right
      anchors.margins: 12
      anchors.verticalCenter: parent.verticalCenter

      source: "qrc:/images/ToolbarIcons/Common/Close.png"
      height: DeviceManager.ratio(48)
      width: height
      rotation: 180
      asynchronous: true

      opacity: panel.opacity
      enabled: panel.enabled

      MouseArea {
        anchors.fill: parent
        onClicked: {panel.anchors.leftMargin = masterWidth; usersWidgetEnabled = false;}
      }
    }
  }
}
