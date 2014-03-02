//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. All rights reserved.
//

import QtQuick 2.0
import "../../Widgets"

Page {
    logoEnabled    : false
    toolbarTitle   : isMobile ? qsTr("Notice") : qsTr("FIRST Notice")

    Flickable {
        id: flickable
        anchors.fill       : parent
        anchors.margins    : 16
        anchors.topMargin  : 16 + arrangeFirstItem
        contentHeight      : textView.paintedHeight
        flickableDirection : Flickable.VerticalFlick
        interactive        : true

        function ensureVisible(r) {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit {
            id: textView
            activeFocusOnPress       : true
            anchors.fill             : parent
            clip                     : true
            color                    : colors.text
            font.family              : defaultFont
            font.pixelSize           : smartFontSize(12)
            onCursorRectangleChanged : flickable.ensureVisible(cursorRectangle)
            readOnly                 : true
            textFormat               : TextEdit.RichText
            wrapMode                 : TextEdit.WrapAtWordBoundaryOrAnywhere
            onLinkActivated          : Qt.openUrlExternally(link)

            text                     : {
                // START OF HTML DOCUMENT
                "<!DOCTYPE html>"
                        + "<html>"
                        + "<body>"

                // NOTICE
                        + "<h2>FIRST Notice</h2>"
                        + "<p>If you are currently located at a FIRST event, we urge you to use "
                        + "the \"Bluetooth\" option instead of the \"Local Network\" (LAN) option to avoid "
                        + "interference between the robots and the drivers.</p>"
                        + "<p>Please note that we are still developing the Bluetooth chat feature, "
                        + " this means that you should not use this app in the arena. Sorry.</p>"

                // END OF HTML DOCUMENT
                        + "</body>"
                        + "</html>"
            }
        }
    }
}
