//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0
import "../Widgets"

Page {
    logoImageSource : "qrc:/images/Information.png"
    logoSubtitle    : qsTr("Created by the WinT 3794 team")
    logoTitle       : qsTr("WinT Messenger 1.0")
    toolbarTitle    : qsTr("About")

    property int perfectY: 10 + parent.height / 16

    Column {
        y                        : arrangeFirstItem + perfectY
        spacing                  : 8
        //anchors.bottom           : parent.bottom
        //anchors.bottomMargin     : perfectY
        anchors.horizontalCenter : parent.horizontalCenter

        Button {
            text      : qsTr("Website")
            onClicked : Qt.openUrlExternally("http://wint-im.sf.net")
        }

        /*Button {
            text      : qsTr("Acknowledgements")
            onClicked : Qt.openUrlExternally("http://www.thebluealliance.com/team/3794")
        }

        Button {
            text      : qsTr("Credits")
            onClicked : Qt.openUrlExternally("http://www.thebluealliance.com/team/3794")
        }*/
    }
}
