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

    property alias logoTitle: titleText.text
    property alias logoImageSource: image.source
    property alias logoSubtitle: subtitleText.text

    property string toolbarTitle: qsTr("Title")
    property int arrangeFirstItem: logoEnabled ? 1.125 * (logo.y + logo.height + DeviceManager.ratio(12)): toolbar.height + DeviceManager.ratio(4)

    Component.onCompleted: toolbar.text = toolbarTitle
    onVisibleChanged: if (visible) toolbar.text = toolbarTitle

    interactive: flickable
    contentHeight: rootWindow.height
    flickableDirection: Flickable.VerticalFlick

    Item {
        id: logo
        enabled: page.logoEnabled
        visible: page.logoEnabled
        anchors {verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter;}

        Image {
            id: image
            width: height
            smooth: true
            asynchronous: true
            height: DeviceManager.isMobile() ? 5 * titleText.height : 128
            anchors {bottom: titleText.top; bottomMargin: 18; horizontalCenter: parent.horizontalCenter;}
        }

        Label {
            id: titleText
            color: colors.logoTitle
            font.pixelSize: sizes.title
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors {verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter;}
        }

        Label {
            id: subtitleText
            color: colors.logoSubtitle
            font.pixelSize: sizes.subtitle
            verticalAlignment: Text.AlignVCenter
            y: titleText.y + titleText.height + 8
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
