import QtQuick 2.0

Rectangle {
    id: page
    anchors.fill: parent
    color: theme.background

    property bool inTabs: parent.hasOwnProperty("selectedPage")
    property var currentPage: inTabs ? parent.selectedPage : pageStack.currentPage
    visible: inTabs ? currentPage === page : false

    property string title
    property int count
    property bool closeable
    property bool show: true

    property bool dynamic: false

    signal close

    property list<Item> leftWidgets: [
        Button {
            flat: true
            iconName: "chevron-left"
            onClicked: pageStack.pop()
            visible: pageStack.count > 1 && pageStack.count == page.z
        }
    ]

    property list<Item> rightWidgets

    property alias preferencesMenuEnabled: preferences.enabled
    property var menu: ActionPopover {
        actions: [
            Action {
                name: "About"
                onTriggered: aboutSheet.open()
            },

            Action {
                id: preferences
                name: "Preferences"
                onTriggered: preferencesSheet.open()
            },

            Action {
                name: "Donate"
            }
        ]
    }

    function push() {
        z = pageStack.count
        pushAnimation.start()
    }

    function init() {
        x = 0
        visible = true
    }

    function pop() {
        popAnimation.start()
    }

    SequentialAnimation {
        id: pushAnimation
        ScriptAction {
            script: visible = true
        }

        ParallelAnimation {
            NumberAnimation {
                target: page.anchors
                property: "leftMargin"; duration: 400; from: page.width; to: 0; easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: page.anchors
                property: "rightMargin"; duration: 400; from: -page.width; to: 0; easing.type: Easing.InOutQuad
            }
        }
    }

    SequentialAnimation {
        id: popAnimation

        ParallelAnimation {
            NumberAnimation {
                target: page.anchors
                property: "leftMargin"; duration: 400; to: page.width; from: 0; easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: page.anchors
                property: "rightMargin"; duration: 400; to: -page.width; from: 0; easing.type: Easing.InOutQuad
            }
        }

        ScriptAction {
            script: {
                visible = false
                if (dynamic)
                    page.destroy()
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: menu.close()
    }

    PreferencesSheet {
        z: 100
        id: preferencesSheet
    }
}
