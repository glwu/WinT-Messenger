import QtQuick 2.2
import "ListItems" as ListItem

//-----------------------------------------------------------------------------//
// Shows a popover with a list of actions. In other words, this class          //
// can create a structure similar to a menubar. For a graphical representation //
// the menu that lists the About, Preferences and Donate options is an action  //
// popover.                                                                    //
//-----------------------------------------------------------------------------//

Popover {
    id: popover
    overlayColor: "transparent"

    // Calulate the width and height of the popover
    width: Math.max(units.gu(20), Math.min(implicitWidth, childrenRect.width))
    height: column.height + units.gu(2.2)

    // Create a list of all registered actions
    property list<Action> actions

    // Create a column with the registered actions
    Column {
        id: column

        // Set the anchors of the  column
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: units.gu(1)
        }

        // Create a object for each action
        Repeater {
            id: repeater
            model: popover.actions
            delegate: Column {
                width: parent.width

                // Create a widget with the action data
                ListItem.Standard {
                    showDivider: false
                    height: units.gu(3)
                    highlightable: true
                    text: modelData.name
                    opacity: modelData.enabled ? 1 : 0.75
                    iconName: modelData.iconName
                    style: modelData.style

                    // Close the popover and perform an action
                    onClicked: {
                        if (modelData.enabled) {
                            popover.close()
                            modelData.triggered()
                        }
                    }
                }

                // Add a separator
                Item {
                    height: visible ? units.gu(2) : 0
                    width: parent.width
                    visible: modelData.hasDividerAfter

                    Rectangle {
                        color: "gray"
                        width: parent.width
                        height: device.ratio(1)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
