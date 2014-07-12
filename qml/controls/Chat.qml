//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
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

    // Show a notification when an user leaves or enters the room
    Connections {
        target: bridge
        onDelUser: notification.show(qsTr("%1 has left the room").arg(nick))
        onNewUser: {
            userSidebar.addUser(nick, face)
            notification.show(qsTr("%1 has joined the room").arg(nick))
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

            // Create a badge that displays the number of connected users
            Rectangle {
                id: badge
                smooth: true

                // Setup the anchors
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: -parent.width / 5 + device.ratio(1)

                // Set a redish color (exactly the one used in OS X 10.10)
                color: "#ec3e3a"

                // Make the rectangle a circle
                radius: width / 2

                // Setup height of the rectangle
                height: device.ratio(18)

                // Make the rectangle and ellipse if we have more than 100 users
                width: usersModel.count > 99 ? countLabel.paintedWidth + height / 2 : height

                // Create a label that will display the number of connected users.
                Label {
                      id: countLabel
                      color: "#fdfdfdfd"
                      anchors.fill: parent
                      text: usersModel.count
                      font.pixelSize: device.ratio(9)
                      anchors.margins: -parent.width / 5 + device.ratio(1)
                      verticalAlignment: Text.AlignVCenter
                      horizontalAlignment: Text.AlignHCenter
                }
            }
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
        id: chatControls

        // Anchor the chat item to the window and the sidebar
        anchors.topMargin: 0
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: userSidebar.left
        anchors.bottom: messageControls.top
        anchors.leftMargin: device.ratio(5)
        anchors.rightMargin: device.ratio(-1)

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
                    id: messageRect
                    color: "transparent"

                    // Set the initial value of x so that the message is hidden
                    x: localUser ? chatControls.width : -chatControls.width

                    // Set the size of the rectangle
                    height: background.height + device.ratio(21)
                    width: childrenRect.width + device.ratio(20)

                    // This is the animation used to apply the x
                    NumberAnimation {
                        id: xAni
                        property: "x"
                        duration: 200
                        target: messageRect
                        to: localUser ? chatControls.width - 2 * width : 0

                        onStopped: {
                          anchors.left = localUser ? undefined : parent.left
                          anchors.right = localUser ? parent.right : undefined
                        }
                    }

                    // Resize the rectangle when the window is resized
                    Connections {
                        target: chatControls

                        onWidthChanged: {
                            background.calculateWidth()
                            background.calculateHeight()
                        }

                        onHeightChanged: {
                            height = background.height + device.ratio(21)
                        }
                    }

                    // Create an intro effect when created, to do this, we apply an initial
                    // opacity to 0 and a x value that will make the control to appear out of the screen,
                    // then when the rectangle is completely loaded, we change the opacity and x to a correct value.
                    opacity: 0
                    Component.onCompleted: {
                      opacity = 1
                      xAni.start()
                    }

                    // To apply the opacity effect, we need to define what should this object
                    // do when the opacity changes
                    Behavior on opacity {NumberAnimation{}}

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
                        anchors.left: !localUser ? parent.left : undefined

                        // Show the image to the right if the message is from the
                        // local user.
                        anchors.right: localUser ? parent.right : undefined

                        // Create a border around the image
                        Rectangle {
                            color: "transparent"
                            anchors.fill: parent

                            border.color: theme.borderColor
                            border.width:  {
                                if (image.source.toString().search(".png") == -1)
                                    return 1
                                else
                                    return 0
                            }
                        }
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
                        anchors.left: !localUser ? image.right : undefined

                        // Show the rectangle to the right if the message is from the
                        // local user.
                        anchors.right: localUser ? image.left : undefined

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
                                if (!localUser)
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

        // Anchor the menu to the user side bar, so that we can display all
        // emotes correctly even if the user side bar is shown.
        anchors.rightMargin: userSidebar.expanded ? userSidebar.width : 0
        Behavior on anchors.rightMargin {NumberAnimation{}}

        // Hide the caption
        captionVisible: false

        // Define the size of each cell
        cellWidth: device.ratio(36)
        cellHeight: device.ratio(36)

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
                color: "#49759C"

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
                    sendTextbox.text = sendTextbox.text + " [s]" + modelData + "[/s] "
                }
            }
        }

        // Load the C++ QStringList created in main.cpp (line 72-73).
        // This list contains all emotes of the app.
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
            bottom: emotesMenu.top
            right: userSidebar.left

            // Avoid the 'double border' issue
            rightMargin: device.ratio(-1)
            bottomMargin: device.ratio(-1)
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
            toggleButton: true
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
        autoFlick: true
        header: qsTr("Connected users")

        // Toggle the visibility of the connected users
        function toggle() {
            expanded = !expanded
        }

        // Append a new user
        function addUser(nick, face) {
              usersModel.append({"name": nick, "face": face, "index": usersModel.count})
        }

        // Add the local user to the users list
        Component.onCompleted: addUser(qsTr("You"), settings.value("face", "astronaut.jpg"))

        // Create the scroll view the registered users
        contents: Controls.ScrollView {
            anchors.fill: parent

            // Create a list view with the registered users
            ListView {
                anchors.fill: parent

                // Setup the list model, other objects can manage the list model using
                // the addUser(string, string) and delUser(string) functions
                model: ListModel {
                    id: usersModel
                }

                // Create a row with the name of the user and its image
                delegate: Row {
                    id: row
                    x: -userSidebar.width

                    // Create a sliding effect when the component is loaded
                    Component.onCompleted: x = 0
                    Behavior on x {NumberAnimation{}}

                    // Automatically delete the object when its respective user extits
                    // the room
                    Connections {
                        target: bridge
                        onDelUser: {
                            if (nick == name)
                                delAni.start()
                        }
                    }

                    // Create the animation used when deleting the object
                    NumberAnimation {
                        id: delAni
                        target: row
                        property: "x"
                        duration: 200
                        to: userSidebar.width
                        easing.type: Easing.InOutQuad
                        onStopped: usersModel.remove(index)
                    }

                    // Set the height of the row
                    height: device.ratio(56)

                    // Set the spacing
                    spacing: device.ratio(5)

                    // Show the profile picture here
                    Image {
                        width: height
                        visible: parent.visible
                        height: device.ratio(48)
                        source: "qrc:/faces/" + face
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Show the user name and join date/time here
                    Label {
                        id: userName
                        visible: parent.visible
                        textFormat: Text.RichText
                        anchors.verticalCenter: parent.verticalCenter
                        text: name + "<br><font size=" + units.gu(1.2)
                              + "px color=gray>" + qsTr("Joined at ") + dateTime() + "</font>"
                    }
                }
            }
        }

        // This is the warning message displayed when a mobile user tries to open a local file.
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
}
