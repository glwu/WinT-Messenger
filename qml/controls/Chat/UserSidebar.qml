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

Sidebar {
    mode: "right"
    id: userSidebar
    expanded: false
    autoFlick: true
    header: qsTr("Connected users")

    property alias userCount: usersModel.count

    function dateTime() {
        return Qt.formatDateTime(new Date(), "hh:mm:ss AP")
    }

    // Append a new user
    function addUser(nick, face) {
        usersModel.append({"name": nick, "face": face, "index": usersModel.count})
    }

    function clear() {
        usersModel.clear()
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
                Behavior on x {NumberAnimation{ duration: 200 }}

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
                    id: username
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
