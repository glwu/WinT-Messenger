//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.1 as Controls

//--------------------------------------------------------------------------//
// This page allows the user to read and send messages through the network. //
// Please note that this page only sends and reads data from the \c Bridge, //
// this means that this control can be easilly implemented to support many  //
// chat platforms and is not limited to the LAN chat feature.               //
//--------------------------------------------------------------------------//

Page {
    id: chat
    title: qsTr("Chat")
    anchors.fill: parent

    // Create the properties of the page
    property string iconPath
    property bool textChat

    // Return the current date and time. This function is used while drawing
    // the messages on the screen.
    function dateTime() {
        return Qt.formatDateTime(new Date(), "hh:mm:ss AP")
    }

    // Show a warning message on mobile devices if
    // the user tries to open a local file
    function openUrl(url) {
        console.log(url)
        Qt.openUrlExternally(url)
        if (device.isMobile()) {
            if (url.search("file:///") !== -1) {
                warningMessage.open()
                warningMessage.text = qsTr("Cannot open file directly from WinT Messenger, " +
                                           "the requested URL was: " + url)
            }
        }
    }

    // Create the save button near the back button
    leftWidgets: [

        // Make a button that allows the user to save the chat file
        Button {
            flat: true
            iconName: "save"
            visible: !device.isMobile()
            enabled: !device.isMobile()
            textColor: theme.navigationBarText
            onClicked: device.isMobile() ? dialog.open() : bridge.saveChat(textEdit.text)
        }
    ]

    // Create the right widgets, such as the user menu and the app menu
    rightWidgets: [

        // Make a button that allows the user to toggle the user menu
        Button {
            flat: true
            iconName: "user"
            onClicked: userSidebar.toggle()
            textColor: userSidebar.expanded ? theme.getSelectedColor(true) : theme.navigationBarText
        },

        // Make a button that allows the user to show/hide the application menu
        Button {
            flat: true
            iconName: "bars"
            onClicked: menu.toggle(caller)
            textColor: menu.visible ? theme.getSelectedColor(true) : theme.navigationBarText
        }
    ]

    // Refresh the chat interface when we enter and exit the room
    onVisibleChanged: {

        // Stop the chat interface and clear the messages when we go
        // back to the previous page.
        if (!visible) {
            preferencesMenuEnabled = true
            bridge.stopChat()
            listModel.clear()
            textEdit.text = ""
        }

        // Start the chat inteface and welcome the user when the user
        // opens this page.
        else {
            textChat = settings.textChat()
            preferencesMenuEnabled = false
            bridge.startChat()
            textEdit.append(qsTr("Welcome to the chat room!") + "<br/><br/>")
            listModel.append({"from": "","face": "/system/globe.png","message": "Welcome to the chat room!", "localUser": false})
        }
    }

    // Here is the item with all the chat dialogs and controls
    // Here be dragons.
    Item {
        // Anchor the chat item to the window and the sidebar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: userSidebar.left
        anchors.topMargin: 0
        anchors.leftMargin: device.ratio(5)
        anchors.rightMargin: device.ratio(-1)
        anchors.bottomMargin: messageControls.height

        // Append a new message when the Bridge notifies us about a new message
        Connections {
            target: bridge
            onDrawMessage: {
                // Append the message to the bubble messages
                listModel.append({"from": from,"face": face,"message": message,"localUser": localUser})
                listView.positionViewAtEnd()

                // Append the message to the text-based interface
                var msg

                // Change the style of the message based if the message is an user message or a
                // system notification
                if (from)
                    msg = "<font color=\"" + color + "\">[" + dateTime() + "] &lt;" + from + "&gt;</font> " + message
                else
                    msg = "<font color=\"#bebebe\">* " + message

                // Append the message to the text edit
                textEdit.append(msg)

                // Play a sound when the message is drawn
                if (settings.soundsEnabled())
                    bridge.playSound()
            }
        }

        // Show all the messages in a text-based environment
        Controls.ScrollView {
            // Show this widget when the text-based interface is enabled.
            visible: textChat
            enabled: textChat

            // Set the anchors of the object
            anchors.fill: parent
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            anchors.leftMargin: device.ratio(5)

            // Create a flickable with the text edit
            Flickable  {
                id: flick
                clip: true

                // Set the anchors of the flickable
                anchors.fill: parent

                // Set the size of the flickable
                contentWidth: textEdit.paintedWidth
                contentHeight: textEdit.paintedHeight

                // Enable autoscrolling when a new message is appended
                function ensureVisible(r) {
                    if (contentX >= r.x)
                        contentX = r.x;
                    else if (contentX + width <= r.x + r.width)
                        contentX = r.x + r.width-width;
                    if (contentY >= r.y)
                        contentY = r.y;
                    else if (contentY + height <= r.y + r.height)
                        contentY = r.y + r.height-height;
                }

                // Create the text edit
                TextEdit {
                    id: textEdit
                    readOnly: true
                    anchors.fill: parent
                    color: theme.textColor
                    visible: parent.visible
                    enabled: parent.enabled
                    font.family: global.font
                    textFormat: TextEdit.RichText
                    onLinkActivated: openUrl(link)
                    font.pixelSize: units.fontSize("medium")
                    onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                }
            }
        }

        // This list view shows all the bubble messages (with a scrollbar)
        Controls.ScrollView {

            // Set the anchors of the object
            anchors.fill: parent
            anchors.margins: 0

            // Show this widget when the text-based interface is disabled.
            enabled: !textChat
            visible: !textChat

            ListView {
                id: listView
                anchors.fill: parent
                anchors.rightMargin: device.ratio(6)

                // Show this widget when the text-based interface is disabled.
                visible: parent.visible
                enabled: parent.enabled

                // The list model with the message data
                model: ListModel {
                    id: listModel
                }

                // This is the message itself
                delegate: Rectangle {
                    color: "transparent"

                    // Set the size of the rectangle
                    width: device.ratio(1 )
                    height: background.height + device.ratio(21)

                    // Resize the rectangle when the window is resized
                    Connections {
                        target: app
                        onWidthChanged: {
                            background.calculateWidth()
                            background.calculateHeight()
                        }

                        onHeightChanged: {
                            height = background.height + device.ratio(21)
                        }
                    }

                    // Show the rectangle to the left if the message is not from
                    // the local user.
                    anchors.left:  localUser != 1 ? parent.left : undefined

                    // Show the rectangle to the right if the message is from the
                    // local user.
                    anchors.right: localUser == 1 ? parent.right : undefined

                    // Create a opacity effect when created, to do this, we apply an initial
                    // opacity of 0, then when the rectangle is completely loaded, we change
                    // the opacity to 1.
                    opacity: 0
                    Component.onCompleted: opacity = 1

                    // To apply the opacity effect, we need to define what should this piece
                    // of shit do when the fucking opacity changes
                    Behavior on opacity {NumberAnimation{}}

                    // Create a nice shadow effect under the profile picture
                    BorderImage {
                        smooth: true
                        anchors.fill: image
                        source: "qrc:/images/shadow.png"

                        border {
                            top: device.ratio(10)
                            left: device.ratio(10)
                            right: device.ratio(10)
                            bottom: device.ratio(10)
                        }

                        anchors {
                            topMargin: -device.ratio(6)
                            leftMargin: -device.ratio(6)
                            rightMargin: -device.ratio(8)
                            bottomMargin: -device.ratio(8)
                        }

                        // Create a opacity effect when created, to do this, we apply an initial
                        // opacity of 0, then when the rectangle is completely loaded, we change
                        // the opacity to 1.
                        opacity: 0
                        Component.onCompleted: {
                            if (image.source.toString().search(".png") == -1)
                                opacity = 0.50
                            else
                                opacity = 0
                        }

                        // To apply the opacity effect, we need to define what should this piece
                        // of shit do when the fucking opacity changes
                        Behavior on opacity {NumberAnimation{}}
                    }

                    // This is the profile picture of each message
                    Image {
                        id: image

                        // Set the size of the image
                        height: width
                        width: device.ratio(64)

                        // Improve the speed of the program by telling
                        // it that it can draw the bubble before the image
                        // is completely loaded.
                        asynchronous: true

                        // Set the source of the image
                        source: "qrc:/faces/" + face

                        // Set the anchors of the image
                        anchors.top: parent.top
                        anchors.margins: device.ratio(12)

                        // Show the image to the left if the message is not from
                        // the local user.
                        anchors.left:  localUser != 1 ? parent.left : undefined

                        // Show the image to the right if the message is from the
                        // local user.
                        anchors.right: localUser == 1 ? parent.right : undefined
                    }

                    // Create a nice shadow effect under the background rectangle
                    BorderImage {
                        smooth: true
                        anchors.fill: background
                        source: "qrc:/images/shadow.png"
                        border {
                            top: device.ratio(10)
                            left: device.ratio(10)
                            right: device.ratio(10)
                            bottom: device.ratio(10)
                        }

                        anchors {
                            topMargin: -device.ratio(6)
                            leftMargin: -device.ratio(6)
                            rightMargin: -device.ratio(8)
                            bottomMargin: -device.ratio(8)
                        }

                        // Create a opacity effect when created, to do this, we apply an initial
                        // opacity of 0, then when the rectangle is completely loaded, we change
                        // the opacity to 1.
                        opacity: 0
                        Component.onCompleted: opacity = 0.50

                        // To apply the opacity effect, we need to define what should this piece
                        // of shit do when the fucking opacity changes
                        Behavior on opacity {NumberAnimation{}}
                    }

                    // This is the background rectangle of each message
                    Rectangle {
                        id: background

                        // Set the background color, the border color and
                        // the radius of the rectangle
                        color: theme.panel
                        radius: device.ratio(2)
                        border.width: device.ratio(1)
                        border.color: theme.borderColor

                        // Set the height of the rectangle based on the painted height
                        // of the text
                        function calculateHeight() {
                            height = text.paintedHeight + device.ratio(24)
                        }

                        function calculateWidth() {

                            // The text is longer than what the standard rectangle can contain,
                            // so we resize the rectangle to show the text completely
                            if (text.paintedWidth > (chat.width * 0.8 - 2 * image.width))
                                width = chat.width * 0.95 - 2 * image.width + device.ratio(32)

                            // The text fits in the standard rectangle
                            else
                                width = text.paintedWidth + device.ratio(32)
                        }

                        // Set the anchors of the rectangle
                        anchors.top: parent.top
                        anchors.topMargin: device.ratio(12)
                        anchors.leftMargin: device.ratio(12)
                        anchors.rightMargin: device.ratio(12)

                        // Show the rectangle to the left if the message is not from
                        // the local user.
                        anchors.left:  localUser != 1 ? image.right : undefined

                        // Show the rectangle to the right if the message is from the
                        // local user.
                        anchors.right: localUser == 1 ? image.left : undefined

                        // Resize the rectangle according to the length of the message
                        Component.onCompleted: {
                            calculateWidth()
                            calculateHeight()
                        }

                        // This is the text of each rectangle
                        Text {
                            id: text

                            // Make sure that the text is drawn smoothly
                            smooth: true

                            // Set the format of the text and font
                            color: theme.textColor
                            font.family: global.font
                            textFormat: Text.RichText
                            font.pixelSize: device.ratio(14)
                            renderType: Text.NativeRendering
                            wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere

                            // Set the anchors of the text
                            anchors.fill: parent
                            anchors.margins: device.ratio(12)

                            // Show a warning when opening local files (URLs with file:///)
                            // on mobile devices using the openUrl(string) function.
                            onLinkActivated: openUrl(link)

                            // Set the size of the text
                            width: parent.width - device.ratio(24)
                            height: parent.height - device.ratio(24)


                            // Add rich text formating and date/time to the message
                            text: {
                                if (localUser != 1)
                                    return message + "<p><font size=" + units.gu(1.2)
                                            + "px color=gray>" + userName + dateTime() + "</font></p>"
                                else
                                    return message + "<p><font size=" + units.gu(1.2)
                                            + "px color=gray>" + dateTime() + "</font></p>"
                            }

                            property string userName: from == "" ?  "" : from + " • "
                        }
                    }
                }
            }
        }
    }

    // This is the emoticon menu
    SlidingMenu {
        id: emotesMenu
        title: qsTr("Emotes")

        // Define the size of each cell
        cellWidth: device.ratio(36)
        cellHeight: device.ratio(36)

        // Make sure that we are shown over the message controls
        anchors.bottomMargin: messageControls.height

        // This is the emoticon button control, which is applied to each emoticon.
        delegate: Rectangle {

            // Set the size of the rectangle that shows each emoticon
            width: height
            height: device.ratio(32)

            // The background of the emoticon control is transpaent
            color: "transparent"

            // Show a rectangle while a emote is hovered
            Rectangle {

                // The background color of the rectangle will differ from the
                // background color of the rectangle
                color: theme.panel

                // Fill the emoticon rectangle
                anchors.fill: parent

                // Decide whenever the rectangle should be visisble or not
                opacity: emotesMouseArea.containsMouse ?  1 : 0
            }

            // The image of each emoticon
            Image {

                // Set the size of the icon
                height: width
                width: device.ratio(25)

                // Make the loading proccess of the Chat control faster
                asynchronous: true

                // Center the image in the emoticon rectangle
                anchors.centerIn: parent

                // Based on the defined emoticonl, oad the image.
                source: "qrc:/emotes/" + modelData
            }

            // This mouse area inserts the selected emoticon in the textbox
            MouseArea {
                id: emotesMouseArea
                anchors.fill: parent
                hoverEnabled: !device.isMobile()
                onClicked: {
                    emotesMenu.toggle()
                    sendTextbox.text = sendTextbox.text + " [s]" + modelData + "[/s] "
                }
            }
        }

        // Load the C++ QStringList created in main.cpp (line 72-73).
        // This shitty list contains all emotes of the app.
        // This proccess is automatic and allows us to add as many emotes as we
        // want through the QRC
        model: emotesList
    }

    // This rectangle stores the messaging controls, such as the
    // send button and the message textbox
    Rectangle {
        id: messageControls
        color: theme.buttonBackground
        border.width: device.ratio(1)
        border.color: theme.borderColor
        height: device.ratio(32)

        // Anchor the controls to the bottom of the page and to the left of the
        // user sidebar
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: userSidebar.left

            // Avoid the 'double border' shit
            rightMargin: device.ratio(-1)
        }

        // This button is used to share files
        Button {
            id: attachButton
            width: parent.height
            iconName: "clip"
            onClicked: device.isMobile() ? dialog.open() : bridge.shareFiles()

            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
        }

        // This line edit is used to type our message
        TextField {
            id: sendTextbox
            placeholderText: qsTr("Type a message...")

            anchors {
                left: attachButton.right
                right: emotesButton.left
                bottom: parent.bottom
                top: parent.top
                rightMargin: device.ratio(-1)
                leftMargin: device.ratio(-1)
            }

            Keys.onReturnPressed: {
                if (length > 0) {
                    bridge.sendMessage(text)
                    text = ""
                }
            }
        }

        // This button is used to add emoticons to our message
        Button {
            id: emotesButton
            width: parent.height
            iconName: "smile-o"
            onClicked: emotesMenu.toggle()
            anchors {
                top: parent.top;
                bottom: parent.bottom;
                right: sendButton.left;
                rightMargin: device.ratio(-1);
            }
        }

        // This button is used to send the message written in sendTextbox
        Button {
            id: sendButton
            iconName: "send"
            enabled: sendTextbox.length > 0 ? 1: 0
            text: device.isMobile() ? "" : qsTr("Send")
            width: device.isMobile() ? height : device.ratio(86)

            anchors {
                right: parent.right
                bottom: parent.bottom
                top: parent.top
            }

            onClicked: {
                bridge.sendMessage(sendTextbox.text)
                sendTextbox.text = ""
            }
        }
    }

    // This dialog is used to share a file to the peers
    OpenFileDialog {
        id: dialog
    }

    // This is the side bar with a list of users
    Sidebar {
        mode: "right"
        id: userSidebar
        expanded: false
        header: qsTr("Connected users")

        // Toggle the visibility of the connected users
        function toggle() {
            expanded = !expanded
        }
    }

    // This is the fucking warning message
    Sheet {
        id: warningMessage
        buttonsEnabled: false
        title: qsTr("Warning")

        property alias text: label.text

        // Create a column with the icon and the controls
        Column {
            spacing: units.gu(0.75)

            // Set the anchors of the column
            anchors.centerIn: parent
            anchors.margins: device.ratio(12)
            anchors.verticalCenterOffset: -units.gu(6)

            // Create the error icon
            Icon {
                name: "cancel"
                fontSize: units.gu(10)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Create the title
            Label {
                fontSize: "x-large"
                text: qsTr("Cannot open file")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Create the subtitle
            Label {
                id: label
                width: warningMessage.width * 0.7
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Finally, create the button to close the message
        Button {
            style: "primary"
            text: qsTr("Close")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(4)
            onClicked: warningMessage.close()
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
