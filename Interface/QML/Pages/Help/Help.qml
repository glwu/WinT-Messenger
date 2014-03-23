//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../../Widgets"

Page {
    logoImageSource : "qrc:/images/Help.png"
    logoSubtitle    : qsTr("Learn the basics of this app")
    logoTitle       : qsTr("Help")
    toolbarTitle    : qsTr("Help")

    property int perfectY: arrangeFirstItem + parent.height / 32

    Column {
        spacing                  : smartSize(4)
        y                        : perfectY
        anchors.horizontalCenter : parent.horizontalCenter

        Button {
            onClicked : openPage("Pages/Help/Documentation.qml")
            text      : isMobile ? qsTr("Help") : qsTr("Documentation")
        }

        Button {
            onClicked : openPage("Pages/Help/AboutQt.qml")
            text      : qsTr("About Qt")
        }

        Button {
            onClicked : openPage("Pages/Help/AboutGPL.qml")
            text      : qsTr("About the GPL 3.0")
        }
    }
}
