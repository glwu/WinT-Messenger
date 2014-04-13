# Copyright (C) 2014 the WinT Team
# Please License.txt and the Authors.txt files for more information

TARGET   = wint-messenger
TEMPLATE = app

# Make sure that all files are enconded in UTF-8
CODECFORTR  = UTF-8
CODECFORSRC = UTF-8

# Import the following Qt components
QT += gui
QT += qml
QT += quick
QT += network
QT += widgets

# Additional options for iOS, Android, Windows & OS X
ios {
    QMAKE_INFO_PLIST   = Systems/iOS/info.plist

    ICONS.files        = $$PWD/Systems/iOS/icon.png
    FONTS.files        = $$PWD/Interface/Resources/Fonts/Regular.ttf
    FONTS.path         = fonts

    QMAKE_BUNDLE_DATA += FONTS
    QMAKE_BUNDLE_DATA += ICONS
}

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/Systems/Android
}

win32* {
    RC_FILE = Systems/Windows/manifest.rc
}

macx {
    QMAKE_INFO_PLIST = Systems/Mac/info.plist
    ICON    = Systems/Mac/icon.icns
    RC_FILE = Systems/Mac/info.plist

    CONFIG += app_bundle
    TARGET = "WinT Messenger"
}

OTHER_FILES += \
    Interface/QML/Widgets/Button.qml \
    Interface/QML/Widgets/ChatInterface.qml \
    Interface/QML/Widgets/Colors.qml \
    Interface/QML/Widgets/Label.qml \
    Interface/QML/Widgets/Page.qml \
    Interface/QML/Widgets/Textbox.qml \
    Interface/QML/Widgets/Toolbar.qml \
    Interface/QML/Widgets/UserInfo.qml \
    Interface/QML/Widgets/Sizes.qml \
    Interface/QML/Pages/About.qml \
    Interface/QML/Pages/Chat.qml \
    Interface/QML/Pages/Connect.qml \
    Interface/QML/Pages/FirstLaunch.qml \
    Interface/QML/Pages/Preferences.qml \
    Interface/QML/Pages/Start.qml \
    Interface/QML/Pages/Hotspot/Wizard.qml \
    Interface/QML/Pages/Help/Documentation.qml \
    Interface/QML/Pages/Help/Help.qml \
    Interface/QML/main.qml

HEADERS += \
    Sources/Common/Headers/Bridge.h \
    Sources/Common/Headers/Emotes.h \
    Sources/Common/Headers/Settings.h \
    Sources/Common/Headers/DeviceManager.h \
    Sources/Chat/Network/Headers/NetChat.h \
    Sources/Chat/Network/Headers/NetClient.h \
    Sources/Chat/Network/Headers/NetConnection.h \
    Sources/Chat/Network/Headers/NetPeerManager.h \
    Sources/Chat/Network/Headers/NetServer.h

SOURCES += \
    Sources/Common/Sources/Bridge.cpp \
    Sources/Common/Sources/Emotes.cpp \
    Sources/Common/Sources/Settings.cpp \
    Sources/Chat/Network/Sources/NetChat.cpp \
    Sources/Chat/Network/Sources/NetClient.cpp \
    Sources/Chat/Network/Sources/NetConnection.cpp \
    Sources/Chat/Network/Sources/NetPeerManager.cpp \
    Sources/Chat/Network/Sources/NetServer.cpp \
    Sources/main.cpp \
    Sources/Common/Sources/DeviceManager.cpp

RESOURCES += \
    Interface/Resources/Emotes/emotes.qrc \
    Interface/Resources/Images/images.qrc \
    Interface/Resources/Fonts/fonts.qrc \
    Interface/QML/qml.qrc

