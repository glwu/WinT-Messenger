import QtQuick 2.2

Widget {

    // Create the properties of the checkbox
    property bool selected
    property var fontSize: "medium"
    property alias text: label.text
    property int margin: label.text !== "" ? units.gu(2) : 0

    // Set the colors of the checkbox
    property color dot
    property color textColor
    property color background
    property color borderColor
    property color background_mouseOver

    // Update the colors of the widget when the theme is changed
    Connections {
        target: theme
        onThemeChanged: {
            // Update the values of the colors when the theme changes
            dot = theme.getSelectedColor(false)
            textColor = theme.textColor
            background = theme.background
            borderColor =  theme.borderColor
            background_mouseOver = theme.buttonBackgroundHover
        }
    }

    // Set the properties of the widget
    height: label.height
    color: theme.background
    onClicked: selected = !selected
    width: label.width + dotRect.width + label.anchors.leftMargin

    // Create the actual checkbox rectangle
    Rectangle {
        id: dotRect

        // Set the size of the rectangle
        width: height
        height: units.gu(2)

        // Make the rectangle have rounded corners by applying a
        // radius of 2 pixels
        radius: units.gu(0.25)

        // Configure the border color
        border.color: borderColor
        border.width: device.ratio(1)

        // Change the color when the mouse passes over the widget
        color: mouseOver ? background_mouseOver : background

        // Set the anchors of the rectangle
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }

        // Create the checked icon
        Icon {
            color: dot

            // Load the text-icon
            name: "check"

            // Change the visibility if the checkbox is visible or not
            opacity: selected ? 1 : 0

            // Set the size of the icon
            size: parent.height * 1.25

            // Center the icon in the checkbox
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -units.gu(0.25)
            anchors.horizontalCenterOffset: units.gu(0.25)

            // Play a fading animation when the opacity changes
            Behavior on opacity {NumberAnimation{}}
        }
    }

    // Create the checkbox label
    Label {
        id: label

        // Set the anchors of the label
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
