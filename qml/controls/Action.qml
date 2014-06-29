import QtQuick 2.2

//------------------------------------------------------------//
// This object allows us to create something similar to a     //
// QAction. As the QAction, this object can be customized to  //
// be displayed in many ways, such as a menu, a toolbar, etc. //
//------------------------------------------------------------//

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
