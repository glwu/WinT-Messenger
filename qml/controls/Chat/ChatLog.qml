//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

import "../Core"
import QtQuick 2.2
import QtQuick.Controls 1.2 as Controls

//--------------------------------------------------------------------------//
// This page allows the user to read and send messages through the network. //
// Please note that this page only sends and reads data from the \c Bridge, //
// this means that this control can be easilly implemented to support many  //
// chat platforms and is not limited to the LAN chat feature.               //
//--------------------------------------------------------------------------//

Rectangle {
    id: chatControls
    property bool textChat: false

    function dateTime() {
        return Qt.formatDateTime(new Date(), "hh:mm:ss AP")
    }

    function formatTextMessage(message, notification) {
        var m_text = notification ? "<font color='" + theme.chatNotification + "'>* " + message + "</font>" : message
        return "<font color='" + theme.chatDateTimeText + "'>" + dateTime() + ":&nbsp;</font>" + m_text
    }

    function clear() {
        textEdit.clear()
        listModel.clear()
    }

    function welcomeUser() {
        textChat = settings.textChat()
        if (textChat)
            textEdit.append(formatTextMessage(settings.value("username", "unknown") + " has joined the room.", true))
        else
            listModel.append({"from": "","face": "/system/globe.png","message": "Welcome to the chat room!", "localUser": false})
    }

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
                    msg = formatTextMessage("&lt;<font color='" + color + "'>" + from + "</font>&gt;&nbsp;" + message, false)


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
        //anchors.fill: parent
        anchors.leftMargin: device.ratio(5)

        // Create a flickable with the text edit, we need to use the flickable
        // so that the text edit can 'auto scroll' on new messages
        Flickable  {
            id: flick
            clip: true

            // Set the anchors of the flickable
            anchors.fill: parent
            anchors.rightMargin: device.ratio(5)

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
                selectByMouse: !device.isMobile()
                selectByKeyboard: !device.isMobile()

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
        anchors.bottomMargin: parent.anchors.bottomMargin

        // Show this widget when the text-based interface is disabled.
        enabled: !textChat
        visible: !textChat

        ListView {
            id: listView
            anchors.fill: parent
            anchors.rightMargin: device.ratio(11)

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
                Behavior on opacity {NumberAnimation{ duration: 200 }}

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
                                        + "px color=gray>" + username + dateTime() + "</font></p>"
                            else
                                return message + "<p><font size=" + units.gu(1.2)
                                        + "px color=gray>" + dateTime() + "</font></p>"
                        }

                        property string username: from == "" ?  "" : from + " • "
                    }
                }
            }
        }
    }
}
