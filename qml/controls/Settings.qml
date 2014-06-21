//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Dialogs 1.1

Dialog {
    id: dialog
    dHeight: device.ratio(296)
    dWidth: parent.width * 0.95
    Component.onCompleted: updateValues()

    // This function is used to get the values of QSettings and apply them
    function updateValues() {
        colorDialog.color = colors.userColor
        darkInterface.checked = settings.darkInterface()
        notifyUpdates.checked = settings.notifyUpdates()
        soundsEnabled.checked = settings.soundsEnabled()

        closeOnBackgroundClicked = !settings.firstLaunch()

        if (settings.firstLaunch())
            closeButton.text = qsTr("Done")
        else
            closeButton.text = qsTr("Close")

        if (settings.firstLaunch())
            show()
        else
            textBox.text = settings.value("userName", "unknown")
    }

    // Draw the contents of the dialog
    contents: Item {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.8

        // Create a column with the controls
        Column {
            width: parent.width
            height: parent.height
            enabled: dialog.enabled
            spacing: device.ratio(8)
            anchors.centerIn: parent

            // This label is used to indicate the user profile settings
            Label {
                anchors.left: parent.left
                text: qsTr("User profile:")
            }

            // This rectangle is used as a separator
            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(2)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // This rectangle contains the user name textbox, the color chooser
            // and the profile picture chooser.
            Rectangle {
                height: textBox.height
                color: "transparent"
                anchors {left: parent.left; right: parent.right;}

                // This image is used as the profile picture chooser
                Image {
                    height: width
                    id: avatarImage
                    asynchronous: true
                    width: device.ratio(48)
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/faces/" +
                            settings.value("face", "astronaut.jpg")
                    visible: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: avatarMenu.toggle()
                    }
                }

                // This line edit is used to change the nickname of the user
                LineEdit {
                    id: textBox
                    onTextChanged: settings.setValue("userName", text)
                    placeholderText: qsTr("Type a nickname and choose a " +
                                          "profile color")
                    anchors {
                        left: avatarImage.right
                        right: colorRectangle.left
                        leftMargin: device.ratio(4)
                        rightMargin: device.ratio(4)
                    }
                }

                // This rectangle is used to change the profile color
                Rectangle {
                    width: height
                    id: colorRectangle
                    height: textBox.height
                    color: colors.userColor
                    anchors.right: parent.right
                    border.color: colors.borderColor

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: colorDialog.open()
                    }
                }
            }

            // This rectangle is used as a separator
            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(4)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // This label is used to indicate the other settings
            Label {
                text: qsTr("Other settings:")
            }

            // This check box is used to toggle the sound effects
            CheckBox {
                width: height
                id: soundsEnabled
                labelText: qsTr("Enable sound effects")
                onCheckedChanged: settings.setValue("soundsEnabled", checked)
            }

            // This check box is used to toggle the theme
            CheckBox {
                width: height
                id: darkInterface
                labelText: qsTr("Use a dark interface theme")
                onCheckedChanged: {
                    settings.setValue("darkInterface", checked)
                    colors.setColors()
                }
            }

            // This check box is used to toggle the auto-updater feature
            CheckBox {
                width: height
                id: notifyUpdates
                labelText: qsTr("Notify me when a new update is released")
                onCheckedChanged: settings.setValue("notifyUpdates", checked)
            }

            // Another separator
            Rectangle {
                width: height
                color: "transparent"
                height: device.ratio(8)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // This button applies the new settings and closes the dialog
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
                    hide()
                    if (settings.firstLaunch())
                        settings.setValue("firstLaunch", false)
                }
            }
        }
    }

    // This menu contains all the profile pictures
    SlidingMenu {
        id: avatarMenu
        cellHeight: cellWidth
        cellWidth: device.ratio(72)
        title: qsTr("Choose a profile picture")

        // Load all profile images
        model: ListModel {
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

        // Create a rectangle with the image and a mouse area
        // that changes the profile picture when clicked
        delegate: Rectangle {
            width: height
            color: "transparent"
            height: device.ratio(64)

            Rectangle {
                anchors.fill: parent
                color: toolbar.color
                Behavior on opacity {NumberAnimation{duration:100}}
                opacity: avatarMouseArea.containsMouse ? toolbar.opacity : 0
            }

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
                    avatarMenu.toggle()
                    settings.setValue("face", name)
                    avatarImage.source = "qrc:/faces/" + name
                }
            }
        }
    }

    // This is the color dialog used to change the profile color
    ColorDialog {
        id: colorDialog
        title: qsTr("Chose profile color")
        onAccepted : {
            settings.setValue("userColor", color)
            colors.userColor = colorDialog.color
        }
    }
}
