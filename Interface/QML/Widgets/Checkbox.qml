//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.0
import QtQuick.Controls 1.0

CheckBox {
    id: control
    width: height
    property alias labelText: label.text

    Text {
        id: label
        color: colors.text
        font {family: defaultFont; pixelSize: sizes.control;}
        anchors {left: parent.right; verticalCenter: parent.verticalCenter;}

        MouseArea {
            anchors.fill: parent
            onClicked: control.checked = !control.checked
        }
    }
}
