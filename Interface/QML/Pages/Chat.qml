//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../Widgets"

Page {
    id: page

    logoEnabled  : false
    toolbarTitle : qsTr("Chat room")

    Component.onCompleted: {
        enableAboutButton(false)
        enableSettingsButton(false)
    }

    onVisibleChanged: {
        enableAboutButton(!visible)
        enableSettingsButton(!visible)
    }

    ChatInterface {
        id: chatInterface
    }
}
