//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "."
import "../chat"
import "../menus"
import "../dialogs"
import "../controls"

import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.0 as Controls

Window {
    id: _app
    color: theme.background

    property alias app: _app
    property alias units: _units
    property alias theme: _theme
    property alias stack: _stack
    property alias global: _global
    property alias updates: _updates
    property alias overlay: _overlay
    property alias appMenu: _app_menu
    property alias navigationBar: _navBar
    property alias avatarMenu: _avatarMenu
    property alias downloadMenu: _downloadMenu
    property alias notification: _notification
    property bool  mobileDevice: device.isMobile()

    property Page initialPage

    QtObject {
        id: _global
        property string font: "Roboto"
        property var regular_loader: FontLoader { source: "qrc:/fonts/fonts/regular.ttf" }
        property var awesome_loader: FontLoader { source: "qrc:/fonts/fonts/font_awesome.ttf" }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            appMenu.close()
            avatarMenu.close()
        }
    }

    Image {
        cache: false
        opacity: 0.4
        fillMode: Image.Tile
        anchors.fill: parent
        source: "qrc:/textures/textures/background.png"
    }

    Controls.StackView {
        id: _stack
        anchors.fill: parent
        initialItem: initialPage
        anchors.topMargin: _navBar.height
    }

    Theme         { id: _theme        }
    Units         { id: _units        }
    NavigationBar { id: _navBar       }
    Overlay       { id: _overlay      }
    AboutDialog   { id: _about        }
    Preferences   { id: _preferences  }
    UpdatesDialog { id: _updates      }
    DonateDialog  { id: _donate       }
    AvatarMenu    { id: _avatarMenu   }
    AppMenu       { id: _app_menu     }
    Notification  { id: _notification }
    DownloadMenu  { id: _downloadMenu }
}
