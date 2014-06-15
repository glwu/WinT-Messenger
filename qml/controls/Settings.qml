//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Dialogs 1.1

Rectangle {
    x: 0
    y: 0
    id: background
    color: "#80000000"
    opacity: menu.opacity
    width: mainWindow.width
    height: mainWindow.height
    enabled: menu.opacity > 0 ? 1 : 0
    
    function show() {
        menu.opacity = 1
    }
    
    function updateValues() {
        colorDialog.color = colors.userColor
        darkInterface.checked = settings.darkInterface()
        notifyUpdates.checked = settings.notifyUpdates()
        
        if (settings.firstLaunch())
            closeButton.text = qsTr("Done")
        else
            closeButton.text = qsTr("Close")
        
        if (settings.firstLaunch())
            menu.opacity = 1
        else
            textBox.text = settings.value("userName", "unknown")
    }
    
    property bool avatarRectangleEnabled: false
    
    Component.onCompleted: updateValues()
    
    onHeightChanged: {
        if (!avatarRectangleEnabled)
            avatarPanel.anchors.topMargin = height
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!settings.firstLaunch())
                menu.opacity = 0
        }
    }
    
    Rectangle {
        id: menu
        opacity: 0
        anchors.centerIn: parent
        color: colors.background
        height: device.ratio(248)
        width: parent.width * 0.95
        border.color: colors.borderColor
        
        Behavior on opacity {NumberAnimation{duration: 250}}
        MouseArea {anchors.fill: parent; enabled: !settings.firstLaunch()}

        Rectangle {
            color: "transparent"
            anchors.fill: parent
            border.width: device.ratio(2)
            border.color: Qt.lighter(parent.color, 1.2)
        }

        Rectangle {
            color: "transparent"
            anchors.fill: parent
            border.width: device.ratio(1)
            border.color: Qt.darker(parent.color, 1.6)
        }
        
        Column {
            anchors.centerIn: parent
            spacing: device.ratio(8)
            width: parent.width * 0.8
            height: parent.height * 0.8
            enabled: menu.opacity > 0 ? 1 : 0
            
            Label {
                anchors.left: parent.left
                text: qsTr("User profile:")
            }
            
            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(2)
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Rectangle {
                height: textBox.height
                color: "transparent"
                anchors {left: parent.left; right: parent.right;}
                
                Image {
                    height: width
                    id: avatarImage
                    asynchronous: true
                    width: device.ratio(48)
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/faces/" + settings.value("face", "astronaut.jpg")
                    visible: true
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (avatarRectangleEnabled) {
                                avatarRectangleEnabled = false;
                                avatarPanel.anchors.topMargin = background.height;
                            }
                            
                            else {
                                avatarRectangleEnabled = true;
                                avatarPanel.anchors.topMargin = background.height / 2;
                            }
                        }
                    }
                }
                
                LineEdit {
                    id: textBox
                    onTextChanged: settings.setValue("userName", text)
                    placeholderText: qsTr("Type a nickname and choose a profile color")
                    anchors {
                        left: avatarImage.right
                        right: colorRectangle.left
                        leftMargin: device.ratio(4)
                        rightMargin: device.ratio(4)
                    }
                }
                
                Rectangle {
                    width: height
                    id: colorRectangle
                    height: textBox.height
                    color: colorDialog.color
                    anchors.right: parent.right
                    border.color: colors.borderColor
                    onColorChanged: settings.setValue("userColor", colors.userColor)
                    
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: colorDialog.open()
                    }
                }
            }
            
            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(4)
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Label {
                text: qsTr("Other settings:")
            }
            
            
            CheckBox {
                width: height
                id: darkInterface
                labelText: qsTr("Use a dark interface theme")
                onCheckedChanged: {settings.setValue("darkInterface", checked); colors.setColors();}
            }
            
            CheckBox {
                width: height
                id: notifyUpdates
                labelText: qsTr("Notify me when a new update is released")
                onCheckedChanged: settings.setValue("notifyUpdates", checked)
            }
            
            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(8)
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Button {
                id: closeButton
                anchors.horizontalCenter: parent.horizontalCenter
                
                enabled: {
                    if (settings.firstLaunch())
                        if (textBox.text.length < 3)
                            return false
                    return true
                }
                
                onClicked: {
                    menu.opacity = 0
                    if (settings.firstLaunch())
                        settings.setValue("firstLaunch", false)
                }
            }
        }
    }
    
    ColorDialog {
        id: colorDialog
        title: qsTr("Chose profile color")
        onAccepted : {
            settings.setValue("userColor", color)
            colors.userColor = colorDialog.color
        }
    }
    
    Rectangle {
        color: "#444"
        id: avatarPanel
        enabled: avatarRectangleEnabled
        anchors {fill: parent; topMargin: parent.height}
        opacity: avatarPanel.anchors.topMargin < background.height ? 1 : 0
        
        Behavior on opacity {NumberAnimation{}}
        Behavior on anchors.topMargin {NumberAnimation{}}
        
        GridView {
            model: avatarModel
            cellWidth: cellHeight
            cellHeight: device.ratio(64)
            anchors {
                fill: parent
                margins: device.ratio(12);
                topMargin: avatarCaptionRectangle.y + avatarCaptionRectangle.height + anchors.margins
            }
            
            delegate: Rectangle {
                width: height
                height: device.ratio(64)
                color: avatarMouseArea.containsMouse ? colors.darkGray : "transparent"
                
                Image {
                    height: width
                    asynchronous: true
                    width: device.ratio(48)
                    anchors.centerIn: parent
                    source: "qrc:/faces/" + name
                }
                
                MouseArea {
                    id: avatarMouseArea
                    anchors.fill: parent
                    hoverEnabled: !device.isMobile()
                    onClicked: {
                        settings.setValue("face", name)
                        avatarRectangleEnabled = false
                        avatarPanel.anchors.topMargin = background.height
                        
                        avatarImage.source = "qrc:/faces/" + name
                    }
                }
            }
            
            ListModel {
                id: avatarModel
                ListElement {name: "astronaut.jpg"}
                ListElement {name: "cat-eye.jpg"}
                ListElement {name: "chess.jpg"}
                ListElement {name: "coffee.jpg"}
                ListElement {name: "dice.jpg"}
                ListElement {name: "energy-arc.jpg"}
                ListElement {name: "fish.jpg"}
                ListElement {name: "flake.jpg"}
                ListElement {name: "flower.jpg"}
                ListElement {name: "grapes.jpg"}
                ListElement {name: "guitar.jpg"}
                ListElement {name: "launch.jpg"}
                ListElement {name: "leaf.jpg"}
                ListElement {name: "lightning.jpg"}
                ListElement {name: "penguin.jpg"}
                ListElement {name: "puppy.jpg"}
                ListElement {name: "sky.jpg"}
                ListElement {name: "sunflower.jpg"}
                ListElement {name: "sunset.jpg"}
                ListElement {name: "yellow-rose.jpg"}
                ListElement {name: "baseball.png"}
                ListElement {name: "butterfly.png"}
                ListElement {name: "soccerball.png"}
                ListElement {name: "tennis-ball.png"}
            }
        }
        
        Rectangle {
            height: toolbar.height
            opacity: toolbar.opacity
            id: avatarCaptionRectangle
            color: colors.darkGray
            anchors {left: parent.left; right: parent.right; top: parent.top;}
            
            Label {
                height: device.ratio(48)
                color: colors.toolbarText
                text: qsTr("Choose a face")
                font.pixelSize: sizes.large
                verticalAlignment: Text.AlignVCenter
                anchors {left: parent.left; margins: 12; verticalCenter: parent.verticalCenter;}
            }
            
            Image {
                width: height
                asynchronous: true
                id: avatarCloseButton
                height: device.ratio(48)
                opacity: avatarPanel.opacity
                enabled: avatarPanel.enabled
                source: "qrc:/icons/ToolbarIcons/Common/Close.png"
                anchors {right: parent.right; margins: device.ratio(12); verticalCenter: parent.verticalCenter;}
                
                Behavior on opacity {NumberAnimation{}}
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        avatarRectangleEnabled = false
                        avatarPanel.anchors.topMargin = background.height
                    }
                }
            }
        }
    }
}
