//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0
import "../Widgets"

Page {
    id: page

    logoEnabled  : false
    toolbarTitle : qsTr("LAN Chat")

    ChatInterface {
        id: chatInterface
    }
}
