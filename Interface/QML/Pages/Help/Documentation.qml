//
//  This file is part of the WinT IM
//
//  Created on Jan, 8, 2014.
//  Copyright (c) 2014 WinT 3794. Refer to Authors.txt for more infomration
//

import QtQuick 2.2
import "../../Widgets"

Page {
    logoEnabled    : false
    toolbarTitle   : isMobile ? qsTr("Help") : qsTr("Documentation")

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
            font.pointSize           : isMobile ? 12 : 8
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

                // INTRODUCTION
                        + "<h2>Introduction</h2>"
                        + "<p>WinT Messenger, as its name says, is an instant messenger software. "
                        + "In contrast to most messaging clients, WinT Messenger is free, open source and does not require any type of registration in order to use it. "
                        + "WinT Messenger is made in QML/C++ and its based on the Qt framework. "
                        + "WinT Messenger is officially supported on Android, iOS, Microsoft Windows, Mac OS X and Linux. "
                        + "Unlike other messaging clients, WinT IM connects to you local network, allowing anyone on your network to join the conversation. "
                        + "In the near future, WinT Messenger will support Bluetooth connections.</p>"

                // FEAUTURES
                        + "<h2>Features</h2>"
                        + "<ul>"
                        + "<li>Easy and friendly to use interface</li>"
                        + "<li>Cross-platform on Windows, Mac OS X, Linux, Android and iOS</li>"
                        + "<li>Fully <a href=\"https://github.com/WinT-3794/WinT-Messenger\">open source</a> and <a href=\"http://sf.net/projects/wint-im\">actively developed</a></li>"
                        + "<li>Does not require an account to use it</li>"
                        + "<li>Supports network chat and (soon) device-to-device blue-tooth chat and ad-hoc chat</a>"
                        + "</ul>"

                // ABOUT US
                        + "<h2>About the WinT team</h2>"
                        + "<p>Working in New Technologies, aka WinT, is a Mexican team formed by TECMilenio students, in Toluca, Mexico. "
                        + "WinT is a team committed with the society and technology. Our goal is to promote the "
                        + "use of science and technology to solve local problems and have a positive impact in our community.</p>"

                        + "<p><h3>Mission:</h3></p>"
                        + "<ul><li>Promote the use of science and technology among the teenagers of our "
                        + "society through the active participation in our community.</li>"
                        + "<li>Represent Mexico in an international event, by building a "
                        + "robot under the values of collaborative work, security, fellowship, "
                        + "competitiveness and respect.</li></ul>"

                        + "<p><h3>Vision:</h3></p>"
                        + "<ul><li>Be the best mexican team, hoping that from this experience students "
                        + "learn  and involve the community to join and support "
                        + "this competition.</li></ul>"

                // ACKNOWLEDGEMENTS
                        + "<h2>Acknowledgements</h2>"
                        + "<p>WinT IM uses the following:</p>"
                        + "<ul>"
                        + "<li>Some of the icons provided by the <a href = 'http://developer.android.com/design/index.html'>Android Develeoper page</a>.</li>"
                        + "<li>The Softie icons (provided by <a href = 'http://www.elegantthemes.com'>Elegant Themes</a>).</li>"
                        + "<li>Part of the code found on the <a href = 'http://harmattan-dev.nokia.com/docs/library/html/qtmobility/btchat.html'>Bluetooth Chat example</a>.</li>"
                        + "<li>Part of the code found on the <a href = 'http://qt-project.org/doc/qt-4.8/network-network-chat.html'>Network Chat example</a>.</li>"
                        + "</ul>"

                /*// FREQUENTLY ASKED QUESTIONS
                        + "<h2>Frequently Asked Questions</h2>"
                        + "<ol>"

                // QUESTION #1
                        + "<li><b>Question #1?</b></li>"
                        + "<ul><li>Answer #1.</li></ul>"

                // QUESTION #2
                        + "<li><b>Question #2?</b></li>"
                        + "<ul><li>Answer #2.</li></ul>"

                // QUESTION #3
                        + "<li><b>Question #3?</b></li>"
                        + "<ul><li>Answer #3.</li></ul>"

                // QUESTION #4
                        + "<li><b>Question #4?</b></li>"
                        + "<ul><li>Answer #4.</li></ul>"

                // QUESTION #5
                        + "<li><b>Question #5?</b></li>"
                        + "<ul><li>Answer #5.</li></ul>"

                // QUESTION #6
                        + "<li><b>Question #6?</b></li>"
                        + "<ul><li>Answer #6.</li></ul>"

                // QUESTION #7
                        + "<li><b>Question #7?</b></li>"
                        + "<ul><li>Answer #7.</li></ul>"

                // END OF FAQ
                        + "</ol>"*/

                // END OF HTML DOCUMENT
                        + "</body>"
                        + "</html>"
            }
        }
    }
}
