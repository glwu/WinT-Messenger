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
    logoSubtitle    : qsTr("Learn to use IM")
    logoTitle       : qsTr("Help")
    toolbarTitle    : qsTr("Help")

    Column {
        spacing                  : 8
        y                        : arrangeFirstItem
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
