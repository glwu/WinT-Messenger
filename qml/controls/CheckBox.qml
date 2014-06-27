import QtQuick 2.0

Widget {

    // Create the properties of the checkbox
    property bool selected
    property var fontSize: "medium"
    property alias text: label.text
    property color dot: theme.primary
    property color textColor: theme.textColor
    property color background: theme.background
    property color borderColor: theme.borderColor
    property int margin: label.text !== "" ? units.gu(2) : 0
    property color background_mouseOver: theme.buttonBackgroundHover

    // Set the properties of the widget
    height: label.height
    color: theme.background
    onClicked: selected = !selected
    width: label.width + dotRect.width + label.anchors.leftMargin

    // Create the actual checkbox rectangle
    Rectangle {
        id: dotRect
        width: height
        height: units.gu(2)
        radius: units.gu(0.25)
        border.color: borderColor
        border.width: device.ratio(1)
        color: mouseOver ? background_mouseOver : background

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }

        // Create the checked icon
        Icon {
            anchors.centerIn: parent
            name: "check"
            color: theme.primary
            opacity: selected ? 1 : 0
            size: parent.height * 1.25
            anchors.horizontalCenterOffset: units.gu(0.25)
            anchors.verticalCenterOffset: -units.gu(0.25)

            Behavior on opacity {NumberAnimation{}}
        }
    }

    // Create the checkbox label
    Label {
        id: label
        anchors {
            verticalCenter: parent.verticalCenter
            left: dotRect.right
            leftMargin: units.gu(0.8)
        }

        // Make the checkbox clickable with the label
        MouseArea {
            anchors.fill: parent
            onClicked: selected = !selected
        }
    }
}
