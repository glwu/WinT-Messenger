# Copyright (C) 2014 the WinT Team
# Please License.txt and the Authors.txt files for more information

TARGET   = WinTMessenger
TEMPLATE = app

# Uncomment the following line for building the app statically
#CONFIG  += STATIC

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
    QMAKE_INFO_PLIST = Systems/iOS/info.plist
    RC_FILE          = Systems/iOS/info.plist
    RC_FILE         += Systems/iOS/icon.png
    FONTS.files      = $$PWD/Interface/Resources/Fonts/Regular.ttf
    FONTS.path         = fonts
    QMAKE_BUNDLE_DATA += FONTS
}

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/Systems/Android
}

win32* {
    RC_FILE = Systems/Windows/icon.rc
}

macx {
    ICON    = Systems/Mac/icon.icns
    RC_FILE = Systems/Mac/info.plist
    CONFIG += app_bundle
    QMAKE_INFO_PLIST = Systems/Mac/info.plist
}

RESOURCES += \
    Interface/Resources/Emotes/emotes.qrc \
    Interface/Resources/Images/images.qrc \
    Interface/Resources/Fonts/fonts.qrc \
    Interface/QML/qml.qrc

SOURCES += \
    Sources/main.cpp \
    Sources/emotes.cpp \
    Sources/bridge.cpp \
    Sources/settings.cpp \
    Sources/lan/chat.cpp \
    Sources/lan/client.cpp \
    Sources/lan/connection.cpp \
    Sources/lan/peermanager.cpp \
    Sources/lan/server.cpp

HEADERS += \
    Sources/emotes.h \
    Sources/bridge.h \
    Sources/settings.h \
    Sources/lan/chat.h \
    Sources/lan/client.h \
    Sources/lan/connection.h \
    Sources/lan/peermanager.h \
    Sources/lan/server.h

