//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import QtQuick 2.0

Label {
    smooth: true
    text: icons[name]
    font.pixelSize: iconSize
    font.family: "FontAwesome"
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter

    property string name: ""
    property var iconSize: units.gu(3)

    property var icons: {
        "": "" ,
                "question": "",
                "fa-spinner": "",
                "envelope-o": "",
                "grid": "",
                "google" : "",
                "check-circle": "",
                "check-square-o": "" ,
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
                "ellipse-h": "" ,
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
                "lightbulb": "",
                "comments": "",
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
                "exclamation": "",
                "search": ""
    }
}
