import QtQuick 2.0

QtObject {
    // Set the properties of the action
    property string name
    property string iconName
    property string description
    property bool hasDividerAfter
    property bool enabled: true
    property string style: "default"

    // Allow the developer to use the onTriggered() slot
    signal triggered
}
