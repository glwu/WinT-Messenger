import QtQuick 2.0

Widget {
    id: popup
    opacity: showing ? 1 : 0
    property bool showing: false
    property color overlayColor: "#800000000"

    signal opened

    Behavior on opacity {
        NumberAnimation {}
    }

    onOpacityChanged: {
        if (opacity === 0 && dynamic)
            popup.destroy()
    }

    function toggle(widget) {
        if (showing)
            close()

        else
            open(widget)
    }

    property bool dynamic: false

    function open() {
        showing = true
        opened()
    }

    function close() {
        showing = false
    }

    Rectangle {
        width: 2 * app.width
        height: 2 * app.height
        anchors.centerIn: parent
        color: overlayColor
    }
}
