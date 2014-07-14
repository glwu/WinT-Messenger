//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

import QtQuick 2.2
import QtQuick.Controls 1.2 as Controls

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
    property var activeDownloads: 0

    // Return the current date and time. This function is used while drawing
    // the messages on the screen.
    function dateTime() {
        return Qt.formatDateTime(new Date(), "hh:mm:ss AP")
    }

    function formatTextMessage(message, notification) {
        var m_text = notification ? "<font color='" + theme.chatNotification + "'>* " + message + "</font>" : message
        return "<font color='" + theme.chatDateTimeText + "'>" + dateTime() + ":&nbsp;</font>" + m_text
    }

    // Show a warning message on mobile devices if
    // the user tries to open a local file
    function openUrl(url) {
        console.log(url)
        Qt.openUrlExternally(url)

        if (device.isMobile()) {
            if (url.search("file:///") !== -1) {
                downloadMenu.close()
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

        // Create a button that displays and manages downloads
        Button {
            flat: true
            iconName: "download"
            onClicked: downloadMenu.toggle(caller)
            textColor: downloadMenu.visible ? theme.getSelectedColor(true) : theme.navigationBarText

            // Create the badge that displays the number of downloads
            Badge {
                text: activeDownloads
            }

            // Create the download menu
            Popover {
                id: downloadMenu
                overlayColor: "transparent"

                // This function is used when the user exits the Chat room
                function exit() {
                    close()
                    downloadsModel.clear()
                }

                // Calulate the width and height of the popover
                width: column.width + units.gu(2.2)
                height: column.height + units.gu(2.2)


                // Create the column with the downloads
                Column {
                    id: column
                    y: device.ratio(6)
                    spacing: device.ratio(6)
                    width: downloadsListView.width + device.ratio(24)
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: downloadsScrollView.height + titleRectangle.height + spacing

                    // Create a rectangle with the title of the popover and a clear button
                    Rectangle {
                        id: titleRectangle
                        width: parent.width
                        color: "transparent"
                        height: device.ratio(42)
                        anchors.horizontalCenter: parent.horizontalCenter

                        // Create the title
                        Label {
                            id: downloadsLabel
                            text: qsTr("Downloads")
                            anchors.left: parent.left
                            anchors.margins: device.ratio(12)
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // Create the button
                        Button {
                            text: qsTr("Clear")
                            height: device.ratio(24)
                            width: device.ratio(58)
                            anchors.right: parent.right
                            anchors.margins: device.ratio(12)
                            enabled: downloadsModel.count > 0
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: downloadsModel.clearFinishedDownloads()
                        }

                        // Create a separator
                        Rectangle {
                            height: device.ratio(1)
                            color: theme.borderColor
                            anchors.bottom: parent.bottom
                            width: parent.width - device.ratio(24)
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    // Create a scroll view with all active downloads
                    Controls.ScrollView {
                        id: downloadsScrollView
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: {
                            if (downloadsModel.count > 0)
                                return downloadsListView.contentHeight > app.height * 0.4 ?
                                            app.height * 0.4 : downloadsListView.contentHeight
                            else
                                return noDownloadsLabel.height
                        }

                        // Create a label telling the user that there are no downloads
                        Rectangle {
                            color: "transparent"
                            id: noDownloadsLabel
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            opacity: downloadsModel.count > 0 ? 0 : 1
                            height: downloadsModel.count > 0 ? 0 : device.ratio(56)

                            // Generate the UI effects
                            Behavior on height {NumberAnimation{}}
                            Behavior on opacity {NumberAnimation{}}

                            // Generate the actual label
                            Label {
                                fontSize: "large"
                                anchors.centerIn: parent
                                color: theme.chatNotification
                                text: qsTr("There are no downloads")
                            }
                        }

                        // Create a list view that will display every download
                        ListView {
                            id: downloadsListView
                            //anchors.top: noDownloadsLabel.bottom

                            // Create a new download when the bridge emits the newDownload() signal
                            Connections {
                                target: bridge
                                onNewDownload: {
                                    activeDownloads += 1
                                    downloadsModel.append({"f_name": f_name, "f_size": f_size, "sender": peer_address})
                                }
                            }


                            // Create the list model with all the downloads, this list is used to draw the download rectangles
                            model: ListModel {
                                id: downloadsModel

                                // Code to clear all finished downloads and show a notification
                                signal clearDownloads
                                function clearFinishedDownloads() {
                                    // Create a int with all the downloads prior to cleaning them
                                    var previousCount = count

                                    // Clear all finished downloads
                                    clearDownloads()

                                    // Tell the user that there are no current downloads
                                    if (previousCount == 0)
                                        notification.show("There are no downloads")

                                    // Show a notification informing the user that there are no finished downloads
                                    else if (previousCount - count == 0)
                                        notification.show("There are no finished downloads")

                                    // Tell the user how many downloads we cleared
                                    else
                                        notification.show(qsTr("Cleared %1 finished downloads").arg(previousCount - count))
                                }
                            }

                            // Create the rectangle that holds the download information
                            delegate: Rectangle {
                                id: downloadItem

                                // Tell the user that the download started
                                Component.onCompleted: notification.show(qsTr("Download of %1 started").arg(f_name))

                                // Calculates the correct unit to display a size in bytes
                                function getUnits(bytes) {
                                    if (bytes === 0)
                                        return '0 Bytes';

                                    var k = 1000;
                                    var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
                                    var i = Math.floor(Math.log(bytes) / Math.log(k));

                                    return (bytes / Math.pow(k, i)).toPrecision(3) + ' ' + sizes[i];
                                }

                                property bool finished: false

                                // Update the progress of the download
                                Connections {
                                    target: bridge

                                    // Finish the download and hide the progress bar
                                    onDownloadComplete: {
                                        if (peer_address == sender && d_name == f_name) {
                                            finished = true
                                            activeDownloads -= 1
                                            progressBar.height = 0
                                            progressBar.visible = false
                                            downloadMouseArea.enabled = true
                                            progressLabel.text = downloadItem.getUnits(f_size) + " - " + sender

                                            // Tell the user that the download has finished
                                            notification.show(qsTr("Download of %1 finished!").arg(f_name))
                                        }
                                    }

                                    // Update the value of the progress bar
                                    onUpdateProgress: {
                                        if (peer_address == sender && d_name == f_name) {
                                            console.log("updating progres...") + progress
                                            progressBar.value = progress
                                        }
                                    }
                                }

                                // Remove the rectangle if the user clicks "clear"
                                Connections {
                                    target: downloadsModel
                                    onClearDownloads: finished ? downloadsModel.remove(index) : undefined
                                }

                                // Set the size of the rectangle
                                width: parent.width - device.ratio(2)
                                height: downloadIcon.height + fNameLabel.paintedHeight +
                                        progressBar.height + progressLabel.paintedHeight

                                // Make the rectangle a bit rounded
                                radius: device.ratio(3)

                                // Make the download item hoverable
                                color: downloadMouseArea.containsMouse ? theme.buttonBackgroundHover : "transparent"

                                // Define the width of the progress bar
                                property int controlWidth: (width - device.ratio(12)) * 0.75 - device.ratio(4)

                                // Create a row with the icon and the download information
                                Row {
                                    anchors.fill: parent
                                    spacing: device.ratio(6)
                                    anchors.margins: device.ratio(8)
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    // Create an icon of the file
                                    Image {
                                        width: height
                                        id: downloadIcon
                                        height: device.ratio(48)
                                        source: "qrc:/faces/system/package.png"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    // Create the progress bar with information
                                    Column {
                                        spacing: parent.spacing
                                        anchors.verticalCenter: parent.verticalCenter

                                        // Create a label with the name of the file
                                        Label {
                                            text: f_name
                                            id: fNameLabel
                                            scale: getScale()
                                            width: parent.width
                                            transformOrigin: Item.TopLeft
                                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                                            // Resize the label so that it fits inside the rectangle.
                                            // However, we need to make sure that the text stays visible,
                                            // so if the scaler than 0.65, we will use word wrapping
                                            function getScale() {
                                                var c_scale = 1

                                                if (paintedWidth > width) {
                                                    c_scale = width / paintedWidth

                                                    if (c_scale < 0.65)
                                                        c_scale = 0.65
                                                }

                                                return c_scale
                                            }
                                        }

                                        // Create a progress bar showing the progress of the download
                                        ProgressBar {
                                            id: progressBar
                                            width: downloadItem.controlWidth
                                        }

                                        // Create a label with the progress of the file
                                        Label {
                                            id: progressLabel
                                            font.pixelSize: device.ratio(9)
                                            color: theme.borderColorDisabled
                                            width: downloadItem.controlWidth
                                            //wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                            scale: paintedWidth > width ? (width / paintedWidth) : 1
                                            transformOrigin: Item.TopLeft
                                            text: downloadItem.getUnits((f_size * progressBar.value) / 100) +
                                                  " of " + downloadItem.getUnits(f_size) + " - " + sender
                                        }
                                    }
                                }

                                // Create a mouse area that will help the user open the downloaded file
                                MouseArea {
                                    enabled: false
                                    anchors.fill: parent
                                    id: downloadMouseArea

                                    // Enable the hover feature only in desktop devices
                                    hoverEnabled: !device.isMobile()

                                    // Open the file
                                    onClicked: openUrl("file://" + bridge.getDownloadPath() + f_name)
                                }
                            }
                        }
                    }
                }
            }
        },

        // Make a button that allows the user to toggle the user menu
        Button {
            flat: true
            iconName: "user"
            onClicked: userSidebar.toggle()
            textColor: userSidebar.expanded ? theme.getSelectedColor(true) : theme.navigationBarText

            // Create a badge that displays the number of connected users
            Badge {
                text: usersModel.count
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
            textEdit.clear()
            bridge.stopChat()
            listModel.clear()
            usersModel.clear()
            downloadMenu.exit()
            preferencesMenuEnabled = true
        }

        // Start the chat inteface and welcome the user when the user
        // opens this page.
        else {
            bridge.startChat()
            textChat = settings.textChat()
            preferencesMenuEnabled = false
            userSidebar.addUser(qsTr("You"), settings.value("face", "astronaut.jpg"))

            if (textChat)
                textEdit.append("<br/>" + formatTextMessage(settings.value("userName", "unknown") + " has joined the room.", true))
            else
                listModel.append({"from": "","face": "/system/globe.png","message": "Welcome to the chat room!", "localUser": false})
        }
    }

    // Here is the item with all the chat dialogs and controls
    // Here be dragons.
    Item {
        id: chatControls

        // Close the download menu when this control is clicked
        MouseArea {
            anchors.fill: parent
            onClicked: downloadMenu.close()
        }

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
            onNewUser: {
                if (textChat)
                    textEdit.append(formatTextMessage(nick + qsTr(" has joined the room"), true))
            }

            onDelUser: {
                if (textChat)
                    textEdit.append(formatTextMessage(nick + qsTr(" has left the room"), true))
            }

            onDrawMessage: {
                // Append the message to the bubble messages
                if (!textChat) {
                    listModel.append({"from": from,"face": face,"message": message,"localUser": localUser})
                    listView.positionViewAtEnd()
                }

                else {
                    // Append the message to the text-based interface
                    var msg

                    // Change the style of the message based if the message is an user message or a
                    // system notification
                    if (!from)
                        msg = formatTextMessage(message, true)
                    else
                        msg = formatTextMessage("&lt;<font color='" + color + "'>@" + from + "</font>&gt;&nbsp;" + message, false)


                    // Append the message to the text edit
                    textEdit.append(msg)
                }

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

            // Create a flickable with the text edit, we need to use the flickable
            // so that the text edit can 'auto scroll' on new messages
            Flickable  {
                id: flick
                clip: true

                // Set the anchors of the flickable
                anchors.fill: parent

                // Set the size of the flickable based on the size of the text edit
                contentWidth: width
                contentHeight: textEdit.paintedHeight > chatControls.height ? textEdit.paintedHeight : height

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

                // Show the copy menu when the user right clicks the text
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton

                    onClicked: {
                        // Update the location of the position rectangle
                        posRectangle.x = mouseX
                        posRectangle.y = mouseY

                        if (mouse.button == Qt.RightButton)
                            textEditMenu.open(posRectangle)
                        else
                            textEdit.close()
                    }

                    // This rectangle is used to show the menu under the mouse
                    Rectangle {
                        width: 1
                        height: 1
                        id: posRectangle
                        color: "transparent"
                    }
                }

                // Create the text edit
                TextEdit {
                    // This function is used when the user exits the room
                    function clear() {
                        text = ""
                    }

                    id: textEdit
                    readOnly: true

                    // Make the text selectable
                    selectByMouse: true
                    selectByKeyboard: true

                    // Set the anchors
                    anchors.fill: parent

                    // Set the wrap property of the text
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                    // Set the visual appearance of the control
                    color: theme.chatText
                    font.family: global.font
                    selectionColor: theme.primary
                    font.pixelSize: units.fontSize("medium")

                    // Hide the text edit when textChat is disabled
                    visible: parent.visible

                    // Make the text edit display HTML content
                    textFormat: TextEdit.RichText

                    // Display a warning message on mobile devices when the
                    // user tries to open a local file
                    onLinkActivated: openUrl(link)

                    // Close the text edit menu when the text edit is clicked
                    // with the left button
                    onSelectionStartChanged: textEditMenu.close()

                    // Auto move the text when a new message is added
                    onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)

                    // Create the menu, with the copy and select all actions
                    ActionPopover {
                        id: textEditMenu
                        triangleVisible: false
                        actions: [
                            Action {
                                name: qsTr("Copy")
                                onTriggered: textEdit.copy()
                            },

                            Action {
                                name: qsTr("Select all")
                                onTriggered: textEdit.selectAll()
                            }
                        ]
                    }
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

        // Append a new user
        function addUser(nick, face) {
            usersModel.append({"name": nick, "face": face, "index": usersModel.count})
        }

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
