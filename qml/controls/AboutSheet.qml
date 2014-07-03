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

import QtQuick 2.1

//-----------------------------------------------------------------------------------//
// This sheet displays information about the application and allows the programer to //
// specify the properties of the app and the support links.                          //
//-----------------------------------------------------------------------------------//

Sheet {
    id: sheet

    // Set the title of the dialog
    title: "About"

    // Disable the confirm button
    confirmButton: false

    // Create the properties that are used to draw information about the application
    property string appName
    property string website
    property string reportABug
    property string version
    property string copyright
    property string author
    property string contactEmail
    property string appMotto
    property alias icon: icon.source

    //------------------------------------------//
    // Begin the application information column //
    //------------------------------------------//

    // Create a column with the widgets used to display the information about
    // the application
    Column {

        // Center the column in the dialog
        anchors {
            centerIn: parent

            // Set the margins of the column
            margins: units.gu(3)
            topMargin: units.gu(8)
        }

        // Set a spacing of 12 pixels between widgets
        spacing: units.gu(1.5)

        // This image is used to draw the logo of the application
        Image {
            id: icon

            // Set the size of the icon
            width: device.ratio(128)
            height: device.ratio(128)

            // Make the size of the vector image be the same as
            // the size of the image loader
            sourceSize: Qt.size(width, height)

            // Instruct the image to be loaded at the center of the dialog
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // This label is used to draw the name of the application
        Label {
            fontSize: "x-large"

            // The format of the text will be {App Name} {App Version}
            text: appName + " " + version

            // Instruct the label to be loaded at the center of the dialog
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // This label is used to draw the motto of the application
        Label {
            text: appMotto
            fontSize: "medium"

             // Instruct the label to be loaded at the center of the dialog
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Draw the author and contact email of the application
        Column {
             // Instruct the column to be loaded at the center of the dialog
            anchors.horizontalCenter: parent.horizontalCenter

            // Draw the name of the author
            Label {
                text: author
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Draw the contact email
            Label {
                text: contactEmail
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Draw the "Report bug" and "Website" links
        Label {
            onLinkActivated: Qt.openUrlExternally(link)
            anchors.horizontalCenter: parent.horizontalCenter

            // The format of the text will be {Report a Bug} • {Website}
            text: "<a href=\"" + reportABug +"\">Report a Bug</a> • " +
                  "<a href=\"" + website + "\">Website</a>"
        }
    }

    // Draw the copyright label of the application
    Label {
        text: qsTr(copyright)

        // Anchor the label to the bottom of the dialog
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(0.4)

        // Make the text look smaller and load a grayish color
        color: Qt.lighter(theme.textColor, 1.5)
        font.pixelSize: units.fontSize("small")

        // Instruct the label to be loaded at the center of the dialog
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
