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

    x: settings.x()
    y: settings.y()

    minimumWidth: 320
    minimumHeight: 480

    width: settings.width()
    height: settings.height()

    onXChanged: settings.setValue("x", x)
    onYChanged: settings.setValue("y", y)
    onWidthChanged: settings.setValue("width", width)
    onHeightChanged: settings.setValue("height", height)
    Component.onCompleted: stackView.push("qrc:/qml/pages/start.qml")


    Connections {
        target: bridge
        onUpdateAvailable: {
            if (settings.notifyUpdates()) {
                updateMessage.open()
            }
        }
    }

    FontLoader {
        id: font
        source: "qrc:/fonts/regular.ttf"
    }

    StackView {
        id: stackView
        anchors {fill: parent; topMargin: toolbar.height;}
    }

    Controls.ToolBar {
        id: toolbar
    }

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

    MessageDialog {
        id: updateMessage
        icon: StandardIcon.Information
        title: qsTr("Update available")
        standardButtons: StandardButton.Ignore | StandardButton.Close | StandardButton.Open
        text: qsTr("An update of WinT Messenger is available, do you want to open the official website to install it?")
        onButtonClicked: {
            if (clickedButton === StandardButton.Ignore)
                settings.setValue("notifyUpdates", false)
            else if (clickedButton === StandardButton.Open)
                Qt.openUrlExternally("http://wint-im.sf.net")
        }
    }

    QtObject {
        id: global
        property string font: "Lato"
    }

    QtObject {
        id: sizes
        property int small: device.ratio(12)
        property int large: device.ratio(18)
        property int medium: device.ratio(14)
        property int x_large: device.ratio(22)
        property int x_small: device.ratio(11)
    }

    QtObject {
        id: colors

        property string disabled : "#cbcbcb"
        property string toolbarText : "#fff"
        property string darkGray : "#333"
        property string textFieldPlaceholder: "#aaa"
        property string userColor: settings.value("userColor", "#00557f")

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

        Component.onCompleted: setColors()

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
