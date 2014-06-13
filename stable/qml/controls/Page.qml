//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Flickable {
    id: page

    property bool flickable: true
    property bool logoEnabled: true

    property alias title: titleText.text
    property alias imageSource: image.source
    property alias subtitle: subtitleText.text

    property string toolbarTitle: qsTr("Title")
    property int arrangeFirstItem: logoEnabled ? 
                                       1.125 * (logo.y + logo.height + device.ratio(24)) : 
                                       toolbar.height + device.ratio(4)

    Component.onCompleted: toolbar.title = toolbarTitle
    onVisibleChanged: if (visible) toolbar.title = toolbarTitle

    interactive: flickable
    contentHeight: stackView.height
    flickableDirection: Flickable.VerticalFlick

    Item {
        id: logo
        anchors.centerIn: parent
        visible: page.logoEnabled

        Image {
            id: image
            width: height
            asynchronous: true
            height: device.ratio(128)
            sourceSize: Qt.size(device.ratio(128), device.ratio(128))
            anchors {bottom: titleText.top; bottomMargin: 18; horizontalCenter: parent.horizontalCenter;}
        }

        Label {
            id: titleText
            color: colors.logoTitle
            anchors.centerIn: parent
            font.pixelSize: sizes.large
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            id: subtitleText
            color: colors.logoSubtitle
            font.pixelSize: device.ratio(14)
            verticalAlignment: Text.AlignVCenter
            y: titleText.y + titleText.height + device.ratio(4)
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
