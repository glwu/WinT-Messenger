/*
 * QML Air - A lightweight and mostly flat UI widget collection for QML
 * Copyright (C) 2014 Michael Spencer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2

Widget {
    id: widget

    // Create the properties of the Icon
    property var size
    property string name
    property bool shadow: false
    property alias color: text.color
    property alias weight: text.font.weight
    property alias fontSize: text.font.pixelSize
    property bool rotate: widget.name.match(/.*-rotate/) !== null

    // Set the properties of the widget
    width: text.width
    height: text.height
    mouseEnabled: false

    // Transform simple strings into the actual icon
    property var icons: {
        "envelope-o": "",
                "grid": "",
                "check-circle": "",
                "check-square-o": "",
                "circle": "",
                "exclamation-triangle": "",
                "calendar": "",
                "github": "",
                "file": "",
                "clock": "",
                "bookmark-o": "",
                "user": "",
                "comments-o": "",
                "check": "",
                "ellipse-h": "",
                "ellipse-v": "",
                "save": "",
                "smile-o": "",
                "spinner": "",
                "square-o": "",
                "times": "",
                "times-circle": "",
                "plus": "",
                "bell-o": "",
                "bell": "",
                "chevron-left": "",
                "chevron-right": "",
                "chevron-down": "",
                "cog": "",
                "minus": "",
                "dashboard": "",
                "calendar-empty": "",
                "calendar": "",
                "bars":"",
                "inbox": "",
                "list": "",
                "long-list": "",
                "comment": "",
                "download": "",
                "tasks": "",
                "bug": "",
                "code-fork": "",
                "clock-o": "",
                "pencil-square-o":"",
                "check-square-o":"",
                "picture-o":"",
                "trash": "",
                "code": "",
                "users": "",
                "exchange": "",
                "link": "",
                "settings": "",
                "about": "",
                "clip": "",
                "globe": "",
                "help" : "",
                "heart": "",
                "send": "",
                "refresh": "",
                "confirm": "",
                "cancel": "",
                "save": "",
                "exclamation": ""
    }

    // Load the Font Awesome font
    FontLoader {
        id: fontAwesome
        source: "qrc:/fonts/font_awesome.ttf"
    }

    // Draw the icon as text
    Text {
        id: text
        anchors.centerIn: parent

        property string name: widget.name.match(/.*-rotate/) !== null ?
                                  widget.name.substring(0, widget.name.length - 7) : widget.name

        font.family: fontAwesome.name
        text: widget.icons.hasOwnProperty(name) ? widget.icons[name] : ""
        color: theme.textColor
        style: shadow ? Text.Raised : Text.Normal
        font.pixelSize: units.fontSize(widget.size)

        NumberAnimation on rotation {
            running: widget.rotate
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1100
        }
    }
}
