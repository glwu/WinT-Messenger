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
import QtQuick.Dialogs 1.1

Rectangle {
    color: "transparent"
    anchors.fill: parent

    function open() {
        sheet.open()
    }

    Component.onCompleted: {
        if (settings.firstLaunch())
            sheet.open()
    }

    Sheet {
        z: 1
        id: sheet

        // Set the title of the dialog
        title: "Preferences"
        height: column.height + closeButton.height + units.gu(8)

        // Read the settings when the dialog is created
        Component.onCompleted: updateValues()
        onVisibleChanged: updateValues()

        // Disable all buttons
        buttonsEnabled: false

        // This function is used to get the values of QSettings and apply them
        function updateValues() {
            darkInterface.selected = settings.darkInterface()
            notifyUpdates.selected = settings.notifyUpdates()
            soundsEnabled.selected = settings.soundsEnabled()

            if (settings.firstLaunch()) {
                closeButton.text = qsTr("Done")
            }

            else {
                closeButton.text = qsTr("Close")
                textBox.text = settings.value("userName", "unknown")
            }
        }

        // Create a column with the widgets used to display the information about
        // the application
        // Create a column with the controls
        Column {
            id: column
            width: parent.width
            spacing: device.ratio(8)
            anchors.centerIn: parent

            // This label is used to indicate the user profile settings
            Label {
                anchors.left: parent.left
                anchors.margins: units.gu(1)
                text: "<b>" + qsTr("User profile") + ":</b>"
            }

            Item {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: units.gu(1.5)
                height: avatarImage.height * 1.2

                // Create an horizontal spacer
                Rectangle {
                    id: separator
                    height: width
                    width: units.gu(1.5)
                    color: "transparent"
                }

                // This image is used as the profile picture chooser
                Image {
                    height: width
                    visible: true
                    id: avatarImage
                    asynchronous: true
                    width: device.ratio(48)
                    anchors.left: separator.right
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        color: "transparent"
                        anchors.fill: parent
                        border.width: device.ratio(1)
                        border.color: theme.borderColor
                    }

                    source: "qrc:/faces/" +
                            settings.value("face", "astronaut.jpg")

                    MouseArea {
                        anchors.fill: parent
                        onClicked: avatarMenu.toggle()
                    }
                }

                // This line edit is used to change the nickname of the user
                TextField {
                    id: textBox
                    anchors.margins: units.gu(1)
                    anchors.left: avatarImage.right
                    anchors.right: parent.right
                    anchors.verticalCenter: avatarImage.verticalCenter
                    onTextChanged: settings.setValue("userName", text)
                    placeholderText: qsTr("Type a nickname") + "..."
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
                anchors.left: parent.left
                anchors.margins: units.gu(1)
                text: "<b>" + qsTr("Other settings") + ":</b>"
            }

            Row {
                spacing: device.ratio(8)
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: units.gu(1.5)

                // Createa an horizontal spacer
                Rectangle {
                    height: width
                    width: units.gu(1)
                    color: "transparent"
                }

                // Draw the checkboxes in a column
                Column {
                    spacing: device.ratio(8)

                    // This check box is used to toggle the sound effects
                    CheckBox {
                        width: height
                        id: soundsEnabled
                        text: qsTr("Enable sound effects")
                        onSelectedChanged: settings.setValue("soundsEnabled", selected)
                    }

                    // This check box is used to toggle the theme
                    CheckBox {
                        width: height
                        id: darkInterface
                        text: qsTr("Use a dark interface theme")
                        onSelectedChanged: {
                            settings.setValue("darkInterface", selected)
                            theme.setColors()
                        }
                    }

                    // This check box is used to toggle the auto-updater feature
                    CheckBox {
                        width: height
                        id: notifyUpdates
                        text: qsTr("Notify me when a new update is released")
                        onSelectedChanged: settings.setValue("notifyUpdates", selected)
                    }
                }
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
                primary: true
                id: closeButton
                width: units.gu(22)
                radius: units.gu(0.5)
                anchors.horizontalCenter: parent.horizontalCenter

                enabled: {
                    if (settings.firstLaunch())
                        if (textBox.text.length < 3)
                            return false
                    return true
                }

                onClicked: {
                    sheet.close()
                    if (settings.firstLaunch())
                        settings.setValue("firstLaunch", false)
                }
            }
        }
    }

    // This menu contains all the profile pictures
    SlidingMenu {
        id: avatarMenu
        z: 2
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
                color: theme.panel
                anchors.fill: parent
                opacity: avatarMouseArea.containsMouse ? 1 : 0
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
}
