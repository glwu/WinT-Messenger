//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

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
            textChat.selected = settings.textChat()
            customColor.selected = settings.customColor()
            darkInterface.selected = settings.darkInterface()
            notifyUpdates.selected = settings.notifyUpdates()
            soundsEnabled.selected = settings.soundsEnabled()

            colorDialog.color = theme.userColor

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
                anchors.margins: units.gu(1)
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
                    anchors.right: colorRectangle.left
                    anchors.verticalCenter: avatarImage.verticalCenter
                    onTextChanged: settings.setValue("userName", text)
                    placeholderText: qsTr("Type a nickname") + "..."
                }

                // This rectangle is used to change the profile color
                Rectangle {
                    width: height
                    id: colorRectangle
                    height: textBox.height
                    color: theme.userColor
                    anchors.right: parent.right
                    border.color: theme.borderColor
                    anchors.verticalCenter: avatarImage.verticalCenter

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
                anchors.left: parent.left
                anchors.margins: units.gu(1)
                text: "<b>" + qsTr("Other settings") + ":</b>"
            }

            Row {
                spacing: device.ratio(8)
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: units.gu(1)

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

                    // This check box is used to toggle the text chat interface
                    CheckBox {
                        width: height
                        id: textChat
                        text: qsTr("Enable a text-based chat interface")
                        onSelectedChanged: settings.setValue("textChat", selected)
                    }

                    // This check box is used to toggle the auto-updater feature
                    CheckBox {
                        width: height
                        id: notifyUpdates
                        text: qsTr("Notify me when a new update is released")
                        onSelectedChanged: settings.setValue("notifyUpdates", selected)
                    }

                    // This check box is used to toggle the auto-updater feature
                    CheckBox {
                        width: height
                        id: customColor
                        text: qsTr("Use the profile color to theme the app")
                        onSelectedChanged: {
                            settings.setValue("customColor", selected)
                            theme.setColors()
                        }
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
        model: facesList

        // Create a rectangle with the image and a mouse area
        // that changes the profile picture when clicked
        delegate: Rectangle {
            width: height
            color: "transparent"
            height: device.ratio(64)

            Rectangle {
                color: "#49759C"
                anchors.fill: parent
                opacity: avatarMouseArea.containsMouse ? 1 : 0
            }

            Image {
                height: width
                asynchronous: true
                width: device.ratio(48)
                anchors.centerIn: parent
                source: "qrc:/faces/" + modelData
            }

            MouseArea {
                id: avatarMouseArea
                anchors.fill: parent
                hoverEnabled: !device.isMobile()
                onClicked: {
                    avatarMenu.toggle()
                    settings.setValue("face", modelData)
                    avatarImage.source = "qrc:/faces/" +  modelData
                }
            }
        }
    }

    // This is the color dialog used to change the profile color
    ColorDialog {
        id: colorDialog
        title: qsTr("Chose profile color")
        onRejected: color = theme.userColor
        onAccepted : {
            theme.userColor = color
            settings.setValue("userColor", theme.userColor)
            theme.setColors()
        }
    }
}
