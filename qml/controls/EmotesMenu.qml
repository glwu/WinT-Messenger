//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2

Rectangle {
    color: "#444"
    id: emotesPanel
    enabled: emotesRectangleEnabled
    opacity: emotesPanel.anchors.topMargin < pageHeight ? 1 : 0
    anchors {
        fill: parent
        topMargin: parent.height
        bottomMargin: sendRectangle.height
    }
    
    Behavior on opacity {NumberAnimation{}}
    Behavior on anchors.topMargin {NumberAnimation{}}
    
    property int pageHeight: parent.height
    
    GridView {
        model: emotesModel
        cellWidth: cellHeight
        cellHeight: device.ratio(36)
        anchors {
            fill: parent
            margins: device.ratio(12)
            topMargin: emotesCaptionRectangle.y + emotesCaptionRectangle.height + anchors.margins
        }
        
        delegate: Rectangle {
            width: height
            height: device.ratio(30)
            color: emotesMouseArea.containsMouse ? colors.darkGray : "transparent"
            
            Image {
                height: width
                asynchronous: true
                width: device.ratio(15)                
                anchors.centerIn: parent
                source: "qrc:/emotes/" + name + ".png"
            }
            
            MouseArea {
                id: emotesMouseArea
                anchors.fill: parent
                hoverEnabled: !device.isMobile()
                onClicked: {
                    emotesButton.enabled = true
                    emotesRectangleEnabled = false
                    emotesPanel.anchors.topMargin = pageHeight
                    sendTextbox.text = sendTextbox.text + " [s]" + name + "[/s] "
                }
            }
        }
        
        ListModel {
            id: emotesModel
            ListElement {name: "angel"}
            ListElement {name: "angry"}
            ListElement {name: "aww"}
            ListElement {name: "blushing"}
            ListElement {name: "confused"}
            ListElement {name: "cool"}
            ListElement {name: "creepy"}
            ListElement {name: "crying"}
            ListElement {name: "cthulhu"}
            ListElement {name: "cute_winking"}
            ListElement {name: "cute"}
            ListElement {name: "devil"}
            ListElement {name: "frowning"}
            ListElement {name: "gasping"}
            ListElement {name: "greedy"}
            ListElement {name: "grinning"}
            ListElement {name: "happy_smiling"}
            ListElement {name: "happy"}
            ListElement {name: "heart"}
            ListElement {name: "irritated_2"}
            ListElement {name: "irritated"}
            ListElement {name: "kissing"}
            ListElement {name: "laughing"}
            ListElement {name: "lips_sealed"}
            ListElement {name: "madness"}
            ListElement {name: "malicious"}
            ListElement {name: "naww"}
            ListElement {name: "pouting"}
            ListElement {name: "shy"}
            ListElement {name: "sick"}
            ListElement {name: "smiling"}
            ListElement {name: "speechless"}
            ListElement {name: "spiteful"}
            ListElement {name: "stupid"}
            ListElement {name: "surprised_2"}
            ListElement {name: "surprised"}
            ListElement {name: "terrified"}
            ListElement {name: "thumbs_down"}
            ListElement {name: "thumbs_up"}
            ListElement {name: "tired"}
            ListElement {name: "tongue_out_laughing"}
            ListElement {name: "tongue_out_left"}
            ListElement {name: "tongue_out_up_left"}
            ListElement {name: "tongue_out_up"}
            ListElement {name: "tongue_out"}
            ListElement {name: "unsure_2"}
            ListElement {name: "unsure"}
            ListElement {name: "winking_grinning"}
            ListElement {name: "winking_tongue_out"}
            ListElement {name: "winking"}
        }
    }
    
    Rectangle {
        height: toolbar.height
        opacity: toolbar.opacity
        id: emotesCaptionRectangle
        color: colors.darkGray
        anchors {left: parent.left; right: parent.right; top: parent.top;}
        
        Label {
            text: qsTr("Emotes")
            color: colors.toolbarText
            height: device.ratio(48)
            font.pixelSize: sizes.large
            verticalAlignment: Text.AlignVCenter
            anchors {left: parent.left; margins: 12; verticalCenter: parent.verticalCenter;}
        }
        
        Image {
            width: height
            asynchronous: true
            id: emotesCloseButton
            opacity: emotesPanel.opacity
            enabled: emotesPanel.enabled
            height: device.ratio(48)
            source: "qrc:/icons/ToolbarIcons/Common/Close.png"
            anchors {right: parent.right; margins: device.ratio(12); verticalCenter: parent.verticalCenter;}
            
            Behavior on opacity {NumberAnimation{}}
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    emotesButton.enabled = true
                    emotesRectangleEnabled = false
                    emotesPanel.anchors.topMargin = pageHeight
                }
            }
        }
    }
}
