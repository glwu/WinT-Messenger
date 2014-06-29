import QtQuick 2.2
import "."

Application {
    id: app

    default property alias data: pageStack.data
    property alias background: background.children

    Item {
        id: background
        anchors.fill: parent
    }

    NavigationBar {
        id: navbar
    }

    property alias pageStack: pageStack

    property Page initialPage

    function push(page) {
        pageStack.push(page)
    }

    function pop(page) {
        pageStack.pop()
    }

    Component.onCompleted: {
        if (initialPage)
            pageStack.push(initialPage)
    }

    PageStack {
        id: pageStack

        anchors {
            left: parent.left
            right: parent.right
            top: navbar.bottom
            bottom: parent.bottom
        }
    }

    property Notification notification: notification

    Notification {
        id: notification
    }
}
