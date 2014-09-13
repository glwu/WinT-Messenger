//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../controls"

import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: bubble

    property string to
    property string from
    property string message
    property bool isLocal: false

    function dateTime() {
        return Qt.formatDateTime(new Date(), "hh:mm:ss AP")
    }

    function autoFormat(string) {
        var http, www, mailto;

        www = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
        mailto = /(\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6})/gim;
        http = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim;

        string = string.replace(mailto, '<a href="mailto:$1">$1</a>');
        string = string.replace(http, '<a href="$1" target="_blank">$1</a>');
        string = string.replace(www, '$1<a href="http://$2" target="_blank">$2</a>');

        string = bridge.manageSmileys(string)

        return string
    }

    function assignConversation(user) {
        if (isLocal && user !== to) {
            height = 0
            visible = false
        }

        else if (!isLocal && user !== from) {
            height = 0
            visible = false
        }

        else {
            visible = true
            height = _bg.height + units.scale(21)
        }
    }

    function drawMessage() {
        _bg.calculateWidth()
        _bg.calculateHeight()
        height = _bg.height + units.scale(21)
        width = childrenRect.width + units.scale(20)
    }

    states: [
        State {
            name: "LOCAL_USER"

            AnchorChanges {
                target: triangle
                anchors.right: _bg.right
                anchors.verticalCenter: _bg.verticalCenter
            }

            AnchorChanges {
                target: image
                anchors.right: parent.right
            }

            AnchorChanges {
                target: _bg
                anchors.right: image.left
            }
        },

        State {
            name: "REMOTE_USER"

            AnchorChanges {
                target: triangle
                anchors.left: _bg.left
                anchors.verticalCenter: image.verticalCenter
            }

            AnchorChanges {
                target: image
                anchors.left: parent.left
            }

            AnchorChanges {
                target: _bg
                anchors.left: image.right
            }
        }
    ]

    color: "transparent"
    height: _bg.height + units.scale(21)
    width: childrenRect.width + units.scale(20)

    Component.onCompleted: {
        drawMessage()
        xAni.start()
    }

    Connections {
        target: messageStack
        onWidthChanged: drawMessage()
        onHeightChanged: _drawMessage()

        onUserChanged: {
            assignConversation(user)
        }
    }

    NumberAnimation {
        id: xAni
        property: "x"
        duration: 200
        target: bubble
        to: isLocal ? parent.width - width : 0
        from: isLocal ? parent.width : -parent.width

        onStopped: {
            anchors.left = isLocal ? undefined : parent.left
            anchors.right = isLocal ? parent.right : undefined
        }
    }

    RectangularGlow {
        opacity: 0.5
        width: _bg.width
        height: _bg.height
        anchors.centerIn: _bg
        glowRadius: units.scale(3)
        anchors.verticalCenterOffset: glowRadius
        anchors.horizontalCenterOffset: glowRadius
        color: settings.darkInterface() ? theme.shadow : theme.borderColor
    }

    RectangularGlow {
        opacity: 0.5
        width: triangle.width
        height: triangle.height
        glowRadius: units.scale(3)
        anchors.centerIn: triangle
        rotation: triangle.rotation
        anchors.verticalCenterOffset: glowRadius
        anchors.horizontalCenterOffset: glowRadius
        color: settings.darkInterface() ? theme.shadow : theme.borderColor
    }

    Rectangle {
        id: triangle
        rotation: 45
        height: width
        color: _bg.color
        width: units.gu(2)
        border.width: units.scale(1)
        border.color: _bg.border.color
        anchors.leftMargin: -units.gu(1) + units.scale(2)
        anchors.rightMargin: -units.gu(1) + units.scale(2)
    }

    Image {
        id: image
        height: width
        asynchronous: true
        anchors.top: parent.top
        anchors.margins: units.gu(1.5)
        width: isLocal ? 0 : units.gu(7)
        source: isLocal ? "" : "image://profile-pictures/" + bridge.getId(from)
    }

    Rectangle {
        id: _bg

        function calculateHeight() {
            height = text.paintedHeight + units.gu(3)
        }

        function calculateWidth() {
            if (text.paintedWidth > (bubble.parent.width * 0.8 - units.gu(14)))
                width = bubble.parent.width * 0.95 - units.gu(10)
            else
                width = text.paintedWidth + units.gu(4)
        }

        Component.onCompleted: {
            calculateWidth()
            calculateHeight()
        }

        color: theme.panel
        radius: units.gu(0.25)
        border.color: theme.borderColor

        anchors.top: parent.top
        anchors.bottomMargin: 0
        anchors.margins: units.gu(1.5)

        Label {
            id: text
            anchors.fill: parent
            textFormat: Text.RichText
            anchors.margins: units.gu(1.5)
            font.pixelSize: units.scale(14)
            renderType: Text.NativeRendering
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: {
                if (isLocal)
                    return autoFormat(message) + "<p><font size=" + units.gu(1.2) +
                            "px color=gray>" + dateTime() + "</font></p>"
                else
                    return autoFormat(message) + "<p><font size=" + units.gu(1.2)
                            + "px color=gray>" + from + " • " + dateTime() + "</font></p>"
            }
        }
    }

    Rectangle {
        color: _bg.color
        height: triangle.height
        width: triangle.width / 2

        anchors.left: isLocal ? undefined : _bg.left
        anchors.right: isLocal ? _bg.right : undefined
        anchors.verticalCenter: triangle.verticalCenter
    }
}
