import QtQuick 2.2
import "ListItems" as ListItem

/*!
    \qmltype Sidebar
    \brief A sidebar component for use in adaptive layouts

    To use, simply add an instance to your code, and anchor other components to it.

    To show or hide, set the expanded property.

    By default, the sidebar has a flickable built in, and whatever contents are added
    will be placed in the flickable. When you want this disabled, or want to fill the
    entire sidebar, set the autoFill property to false.

    Examples:
    \qml
        property bool wideAspect: width > units.gu(80)

        Sidebar {
            expanded: wideAspect

            // Anchoring is automatic
        }
    \endqml
*/

Widget {
    id: root

    // Create the properties of the sidebar
    property string mode: "left"
    property bool expanded: false
    property bool autoFlick: true
    property alias header: headerItem.text
    property color borderColor: theme.borderColor
    default property alias contents: contents.data
    property color background: theme.buttonBackgroundHover

    // Toggle the visibility of the connected users
    function toggle() {
        expanded = !expanded
    }

    // Set the properties of the widget
    color: background
    width: expanded ? (app.width > device.ratio(550) ? device.ratio(200) : app.width) : 0

    anchors {
        left: mode === "left" ? parent.left : undefined
        right: mode === "right" ? parent.right : undefined
        top: parent.top
        bottom: parent.bottom
    }

    // Create an animation while the margins increase/decrase
    // this causes the actual sliding of the menu
    Behavior on width {NumberAnimation {}}

    // Create the border rectangle
    Rectangle {
        color: borderColor
        width: 1

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: mode === "left" ? parent.right : undefined
            left: mode === "right" ? parent.left : undefined
        }
    }

    // Create a flickable with the contents of the side bar
    Item {
        id: contents
        width: parent.width
        //height: childrenRect.height

        anchors {
            top: headerItem.visible ? headerItem.bottom : parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            rightMargin: mode === "left" ? device.ratio(5) : 0
            leftMargin: mode === "right" ? device.ratio(5) : 0
        }
    }

    // Create the header of the menu
    ListItem.Header {
        id: headerItem
        visible: text !== ""
    }
}
