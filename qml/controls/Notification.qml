import QtQuick 2.2

Rectangle {
    id: notification

    anchors {
        margins: units.gu(2)
        bottom: parent.bottom
        horizontalCenter: parent.horizontalCenter
    }

    opacity: showing ? 1 : 0
    color: Qt.rgba(0,0,0,0.6)
    width: label.width + units.gu(4.5)
    height: label.height + units.gu(3)
    radius: label.height > label.paintedHeight ? device.ratio(5) : width / 2

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    property bool showing: false
    property string text

    function show(text) {
        notification.text = text
        notification.showing = true
    }

    onShowingChanged: {
        if (showing)
            timer.restart()
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: notification.text
        fontSize: "large"
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        width: paintedWidth + units.gu(4.5) > app.width ?
                   app.width - units.gu(4.5) : paintedWidth
    }

    Timer {
        id: timer
        interval: 4000
        onTriggered: showing = false
    }
}
