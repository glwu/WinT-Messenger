//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Flickable {
  id: page

  property bool flickable: true
  property bool logoEnabled: true

  property alias logoImageSource: image.source
  property alias logoSubtitle: subtitleText.text
  property alias logoTitle: titleText.text

  property string toolbarTitle: qsTr("Title")
  property int arrangeFirstItem: logoEnabled ? 1.125 * (logo.y + logo.height + DeviceManager.ratio(12)): toolbar.height + DeviceManager.ratio(4)

  Component.onCompleted: toolbar.text = toolbarTitle
  onVisibleChanged: if (visible) toolbar.text = toolbarTitle

  contentHeight: rootWindow.height
  interactive: flickable
  flickableDirection: Flickable.VerticalFlick

  Item {
    id: logo
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    enabled: page.logoEnabled
    visible: page.logoEnabled

    Image {
      id: image
      anchors.bottom: titleText.top
      anchors.bottomMargin: 18
      anchors.horizontalCenter: parent.horizontalCenter
      height: DeviceManager.isMobile() ? 5 * titleText.height : 128
      width: height
      smooth: true
      asynchronous: true
    }

    Label {
      id: titleText
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      color: colors.logoTitle
      font.pixelSize: sizes.title
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }

    Label {
      id: subtitleText
      anchors.horizontalCenter: parent.horizontalCenter
      color: colors.logoSubtitle
      font.pixelSize: sizes.subtitle
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      wrapMode: Text.WrapAtWordBoundaryOrAnywhere
      y: titleText.y + titleText.height + 8
    }
  }
}
