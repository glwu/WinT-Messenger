//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../core"
import "../controls"

import QtQuick 2.0

Menu {
    id: _avatarMenu

    height: width * 0.8
    width: app.width < app.height ? app.width * 0.9 : units.gu(32)

    property alias model: _grid.model
    signal updateAvatarImage(string image)

    data: NiceScrollView {
        anchors.fill: parent
        anchors.centerIn: parent

        GridView {
            id: _grid
            model: facesList
            anchors.fill: parent

            cellWidth: units.scale(56)
            cellHeight: units.scale(56)

            delegate: Rectangle {
                width: height
                color: "transparent"
                height: units.scale(52)

                CircularImage {
                    height: width
                    width: units.scale(48)
                    anchors.centerIn: parent
                    source: "qrc:/faces/faces/" + modelData
                }

                MouseArea {
                    id: avatarMouseArea
                    anchors.fill: parent
                    hoverEnabled: !app.mobileDevice
                    onClicked: {
                        avatarMenu.toggle()
                        settings.setValue("face", modelData)
                        avatarMenu.updateAvatarImage(modelData)
                    }
                }
            }
        }
    }
}
