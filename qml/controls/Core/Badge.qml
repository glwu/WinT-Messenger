//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

//----------------------------------------------------------------------------//
// This object allows us to display an Android style badge with a custom text.//
// The anchors and sizes are calculated automatically.                        //
//----------------------------------------------------------------------------//

Rectangle {
    id: badge
    smooth: true

    // Allow the programmer to define the text to display
    property alias text: label.text

    // Create an animation when the opacity changes
    Behavior on opacity {NumberAnimation{ duration: 200 }}

    // Setup the anchors
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: -parent.width / 5 + device.ratio(1)

    // Set a redish color (exactly the one used in OS X 10.10)
    color: "#ec3e3a"

    // Make the rectangle a circle
    radius: width / 2

    // Setup height of the rectangle
    height: device.ratio(18)

    // Make the rectangle and ellipse if the length of the text is bigger than 2 characters
    width: label.text.length > 2 ? label.paintedWidth + height / 2 : height

    // Create a label that will display the number of connected users.
    Label {
        id: label
        color: "#fdfdfdfd"
        anchors.fill: parent
        font.pixelSize: device.ratio(9)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.margins: -parent.width / 5 + device.ratio(1)
    }
}
