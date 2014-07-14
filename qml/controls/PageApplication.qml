import QtQuick 2.2
import "."

Application {
    id: app

    property Page initialPage
    property alias pageStack: pageStack
    default property alias data: pageStack.data
    property alias background: background.children
    property Notification notification: notification

    Component.onCompleted: pageStack.push(initialPage)

    function pop(page)  { pageStack.pop() }
    function push(page) { pageStack.push(page) }

    Item {
        id: background
        anchors.fill: parent
    }

    NavigationBar {
        id: navbar
    }

    PageStack {
        id: pageStack
        anchors.fill: parent
        anchors.topMargin: navbar.height
    }

    Notification {
        id: notification
    }
}
