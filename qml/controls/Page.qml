//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Flickable {
    id: page

    // Make the page flickable
    property bool flickable: true

    // Enable/disable the lofo
    property bool logoEnabled: true

    // Logo properties
    property alias title: titleText.text
    property alias imageSource: image.source
    property alias subtitle: subtitleText.text

    // Toolbar properties
    property string toolbarTitle: qsTr("Title")

    // Arrange the first item based on the visibility of the logo
    property int arrangeFirstItem: logoEnabled ?
                                       1.125 *
                                       (logo.y + logo.height +
                                        device.ratio(24)) :
                                       toolbar.height + device.ratio(4)

    // Update the title of the toolbar when we become visible
    Component.onCompleted: toolbar.title = toolbarTitle
    onVisibleChanged: if (visible) toolbar.title = toolbarTitle

    // Flickable properties
    interactive: flickable
    contentHeight: stackView.height
    flickableDirection: Flickable.VerticalFlick

    // Create the logo (where an icon, a title and a subtitle are shown)
    Item {
        id: logo
        anchors.centerIn: parent
        visible: page.logoEnabled

        // This image is used to show the logo
        Image {
            id: image
            width: height
            asynchronous: true
            height: device.ratio(128)
            sourceSize: Qt.size(device.ratio(128), device.ratio(128))
            anchors {
                bottomMargin: 18
                bottom: titleText.top
                horizontalCenter: parent.horizontalCenter
            }
        }

        // This label is used to show the title
        Label {
            id: titleText
            color: colors.logoTitle
            anchors.centerIn: parent
            font.pixelSize: sizes.large
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        // This label is used to show the subtitle
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
