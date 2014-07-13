//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import "controls"
import QtQuick 2.2
import QtQuick.Controls 1.2 as Controls

//------------------------------------------------------------------------------------//
// This file loads and configures the QML interface and displays it in the QML Window //
//------------------------------------------------------------------------------------//

//---------------------------------------------------------------------------------------//
// The difference between the mobile app and the desktop app is that the URLs are opened //
// differently: mobiles open URLs by defualt in their web browser and desktops open it   //
// in the integrated web viewer.                                                         //
// There also other changes related to the window geometry settings.                     //
//---------------------------------------------------------------------------------------//

PageApplication {
    id: app
    title: "WinT Messenger"

    // Load the \c start page first
    initialPage: start

    // Display a \c notification when there is a new update available
    Connections {
        target: bridge
        onUpdateAvailable: updateMessage.open()
    }

    //---------------------------------//
    // Begin the page creation section //
    //---------------------------------//

    // Create the \c chat page, which allows us to actually send and receive messages over the network.
    Chat {
        id: chat
    }

    // Create the \c start page (the initial page that is loaded in line 40)
    Logo {
        id: start

        // Set the logo icon, the title and the subtitle of the page
        text: qsTr("Welcome")
        title: qsTr("Welcome")
        source: "qrc:/icons/Logo.svg"
        subtitle: qsTr("Please choose an option")

        // Create a column of buttons that will allow the user to navigate through the application
        Column {
            y: start.firstItem
            spacing: units.gu(0.5)
            anchors.horizontalCenter: parent.horizontalCenter

            // Create a button that will allow the user to navigate to the \c Chat page
            Button {
                text: qsTr("Chat")
                width: units.gu(24)
                onClicked: app.push(chat)
            }

            // Create a useless button that will open a browser with the official page of the
            // application. We really need to add another feature that could be more useful, such as
            // a "application statics" page.
            Button {
                text: qsTr("News")
                width: units.gu(24)
                onClicked: Qt.openUrlExternally("http://wint-im.sf.net/news.html")
            }

            // Create a button that will allow the user to navigate to the \c Help page
            Button {
                text: qsTr("Help")
                width: units.gu(24)
                onClicked: app.push(help)
            }
        }
    }

    // Create the \c Help page
    Logo {
        id: help

        // Set the logo icon, the title and the subtitle of the page
        text: qsTr("Help")
        title: qsTr("Get Help")
        source: "qrc:/icons/Help.svg"
        subtitle: qsTr("Need help? Find it here!")

        // Create a column of buttons that will allow the user to browse on different topics.
        Column {
            y: help.firstItem
            spacing: units.gu(0.5)
            anchors.horizontalCenter: parent.horizontalCenter

            // Create a button that will open the web viewer with a Wikipedia article
            // about Qt.
            Button {
                width: units.gu(24)
                text: qsTr("About Qt")
                onClicked: Qt.openUrlExternally("http://en.wikipedia.org/wiki/Qt_(software)")
            }

            // Create a button that will open the web viewer with the user's documentation
            Button {
                width: units.gu(24)
                text: qsTr("Documentation")
                onClicked: Qt.openUrlExternally("http://wint-im.sf.net/doc/doc.html")
            }

            // Create a button that will open the web viewer with the dev's documentation
            Button {
                width: units.gu(24)
                text: qsTr("Dev's documentation")
                onClicked: Qt.openUrlExternally("http://wint-im.sf.net/dev-doc/html/index.html")
            }
        }
    }

    //--------------------------------//
    // Begin the dialog/sheet section //
    //--------------------------------//

    // Create a new about sheet that will display information about the app
    AboutSheet {
        // Identify the dialog
        z: 2
        id: aboutSheet

        // Set the information of the application, such as the application version and
        // the support links.
        version: "1.3.0"
        author: "Alex Spataru"
        appName: "WinT Messenger"
        icon: "qrc:/icons/Logo.svg"
        website: "http://wint-im.sf.net"
        contactEmail: "alex.racotta@gmail.com"
        appMotto: qsTr("Simple and lightweight IM client")
        copyright: qsTr("Copyright (C) 2014 the WinT 3794 team")
        reportABug: "https://github.com/WinT-3794/WinT-Messenger/issues/new"
    }

    // Create a new preferences sheet that will be used to allow the user to customize the interface
    PreferencesSheet {
        // Make sure that the fucking dialog stays on top. Unlike other dialogs, this sheet is created
        // inside a rectangle so that we can allow the profile picture sliding menu to show on top of
        // the dialog. However, this will cause the dialog to be only visible on the initial page.
        // Of course, we don't want that shit to happen, so we force the dialog to stay on top with the
        // \c z property.
        z: 2

        // Identify the dialog
        id: preferencesSheet
    }

    // This is the message shown when a new update is available
    Sheet {
        id: updateMessage
        buttonsEnabled: false
        title: qsTr("Update available")

        // Create a column with the icon and the controls
        Column {
            spacing: units.gu(0.75)

            // Set the anchors of the column
            anchors.centerIn: parent
            anchors.margins: device.ratio(12)
            anchors.verticalCenterOffset: -units.gu(4)

            // Create the download icon
            Icon {
                name: "download"
                fontSize: units.gu(10)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Create the title
            Label {
                fontSize: "x-large"
                width: updateMessage.width * 0.95
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("An update of WinT Messenger is available!")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Create the subtitle
            Label {
                id: label
                width: updateMessage.width * 0.7
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Do you want to open the official website to install it?")
            }

            // Create a label telling the user how to disable the auto-updater
            Label {
                color: theme.borderColor
                font.pixelSize: device.ratio(11)
                width: updateMessage.width * 0.7
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("You can disable the updater by opening the <a href='http://sf.net'>Prefences</a> dialog")

                onLinkActivated: {
                    updateMessage.close()
                    preferencesSheet.open()
                }
            }

        }

        // Finally, create the buttons
        Row {
            spacing: units.gu(2)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(4)
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                style: "primary"
                text: qsTr("Not now")
                onClicked: updateMessage.close()
            }

            Button {
                style: "primary"
                text: qsTr("Yes")
                onClicked: {
                    Qt.openUrlExternally("http://wint-im.sf.net")
                    updateMessage.close()
                }
            }
        }
    }
}
