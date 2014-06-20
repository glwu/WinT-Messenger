//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2
import "controls" as Controls

ApplicationWindow {
    visible: true
    id: mainWindow
    color: colors.background
    title: qsTr("WinT Messenger")

    // Configure the geometry of the window when we create it
    x: settings.x()
    y: settings.y()
    width: settings.width()
    height: settings.height()

    // Save the geometry of the window when
    // it changes (ex: resize the window)
    onXChanged: settings.setValue("x", x)
    onYChanged: settings.setValue("y", y)
    onWidthChanged: settings.setValue("width", width)
    onHeightChanged: settings.setValue("height", height)

    // Avoid having a 0x0 window
    minimumWidth: 320
    minimumHeight: 480

    // Load the start.qml page and print the status of the FontLoader
    Component.onCompleted: {
        stackView.push("qrc:/qml/pages/start.qml")
        loader.status == FontLoader.Ready ?
                    console.log("Font Loaded") :
                    console.log("Error loading font")
    }

    // Load the Roboto font
    FontLoader {
        id: loader
        source: "qrc:/fonts/regular.ttf"
    }

    // Show a message dialog when a new update is available
    Connections {
        target: bridge
        onUpdateAvailable: {
            if (settings.notifyUpdates()) {
                updateMessage.open()
            }
        }
    }

    // Implement the page-based navigation system
    StackView {
        id: stackView
        anchors {fill: parent; topMargin: toolbar.height;}
    }

    // Create the toolbar
    Controls.ToolBar {
        id: toolbar
    }

    // Show a message dialog informing the user about issue #3
    // You can read it at https://github.com/WinT-3794/WinT-Messenger/issues/3
    MessageDialog {
        property string url

        id: warningMessage
        informativeText: url
        icon: StandardIcon.Warning
        title: qsTr("Error opening file")
        standardButtons: StandardButton.Ok
        text: qsTr("Cannot open file directly from WinT Messenger, " +
                   "the file was saved inside " + bridge.getDownloadPath())
    }

    // This is the message dialog used to notify the user about newer versions
    // of the application.
    MessageDialog {
        id: updateMessage
        icon: StandardIcon.Information
        title: qsTr("Update available")

        standardButtons: StandardButton.Ignore |
                         StandardButton.Close  |
                         StandardButton.Open

        text: qsTr("An update of WinT Messenger is available, " +
                   "do you want to open the official website to install it?")

        onButtonClicked: {
            if (clickedButton === StandardButton.Ignore)
                settings.setValue("notifyUpdates", false)
            else if (clickedButton === StandardButton.Open)
                Qt.openUrlExternally("http://wint-im.sf.net")
        }
    }

    // Define the name of the font family
    QtObject {
        id: global
        property string font: "Roboto"
    }

    // Define the standard sizes of the controls
    QtObject {
        id: sizes
        property int small: device.ratio(11)
        property int large: device.ratio(17)
        property int medium: device.ratio(13)
        property int x_large: device.ratio(20)
        property int x_small: device.ratio(10)
    }

    // Define the color theme of the application
    QtObject {
        id: colors

        // These are the static colors
        property string disabled : "#cbcbcb"
        property string toolbarText : "#fff"
        property string darkGray : "#333"
        property string textFieldPlaceholder: "#aaa"
        property string userColor: settings.value("userColor", "#00557f")

        // This are the colors that vary depending if the user choosed to
        // use a dark interface or a light interface
        property string text
        property string logoTitle
        property string logoSubtitle
        property string background
        property string borderColor
        property string buttonBackground
        property string buttonForeground
        property string borderColorDisabled
        property string textFieldBackground
        property string textFieldForeground
        property string buttonBackgroundHover
        property string buttonBackgroundPressed
        property string buttonBackgroundDisabled
        property string buttonForegroundDisabled

        // Call the setColors() function when this object is created
        Component.onCompleted: setColors()

        // Set the colors depending on the theme (dark interface or light)
        function setColors() {
            text = settings.darkInterface() ? "#eee" : "#000"
            logoTitle = settings.darkInterface() ? "#fff" : "#333"
            logoSubtitle = settings.darkInterface() ? "#ddd" : "#666"
            background = settings.darkInterface() ? "#444" : "#f7f7f7"
            borderColor = settings.darkInterface() ? "#555" : "#c7c7c7"
            buttonForeground = settings.darkInterface() ? "#ddd" : "#222"
            textFieldForeground = settings.darkInterface() ? "#ddd" : "#222"
            buttonBackground = settings.darkInterface() ? "#333" : "#ebebeb"
            textFieldBackground = settings.darkInterface() ? "#333" : "#fdfdfd"
            buttonBackgroundPressed = settings.darkInterface() ? "#222" : "#e8e8e8"
            buttonBackgroundHover = settings.darkInterface() ? "#3a3a3a" : "#f2f2f2"
            buttonBackgroundDisabled = settings.darkInterface() ? "#444" : "#efefef"
            buttonForegroundDisabled = settings.darkInterface() ? "#888" : "#838383"
            borderColorDisabled = settings.darkInterface() ? borderColor : "#d9d9d9"
        }
    }
}
