//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../Widgets"

Page {
    logoImageSource : "qrc:/images/Information.png"
    logoSubtitle    : qsTr("Created by the WinT 3794 team")
    logoTitle       : qsTr("WinT Messenger 1.0")
    toolbarTitle    : qsTr("About")

    property int perfectY: 10 + parent.height / 16

    Component.onCompleted: enableSettingsButton(false)
    onVisibleChanged: enableSettingsButton(!visible)

    Column {
        y                        : arrangeFirstItem + perfectY
        spacing                  : 8
        anchors.horizontalCenter : parent.horizontalCenter

        Button {
            text      : qsTr("Website")
            onClicked : Qt.openUrlExternally("http://wint-im.sf.net")
        }
    }
}
