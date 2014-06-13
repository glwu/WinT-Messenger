# Copyright (C) 2014 the WinT Team
# Please License.txt and the Authors.txt files for more information

# Name & version
TARGET   = wint-messenger
TEMPLATE = app
VERSION = 1.2.0

# Make sure that all files are encoded in UTF-8
CODECFORTR  = UTF-8
CODECFORSRC = UTF-8

# Import required Qt modules
QT += gui
QT += qml
QT += core
QT += quick
QT += widgets
QT += network

# OS related stuff
android {
    # Load manifest.xml file and icons
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/sys/android
}

ios {
    # Load customized info.plist file
    QMAKE_INFO_PLIST   = sys/ios/info.plist

    # Point out which files we need to copy to app folder
    ICONS.files = $$PWD/sys/ios/icon.png
    FONTS.files = $$PWD/res/fonts/regular.ttf

    # Copy icons and fonts into application folder
    QMAKE_BUNDLE_DATA += FONTS
    QMAKE_BUNDLE_DATA += ICONS
}

win32* {
    # Load application icon
    RC_FILE = sys/windows/manifest.rc

    # Special configurations for Windows
    TARGET = "WinT Messenger"
}

macx {
    # Load custom info.plist file
    QMAKE_INFO_PLIST = sys/mac/info.plist
    RC_FILE = sys/mac/info.plist

    # Add SSL libraries on OS X
    LIBS += -lcrypto -lssl

    # Load icon.icns into app bundle folder
    ICON = sys/mac/icon.icns
    
    # Special configurations for Mac
    CONFIG += app_bundle
    TARGET = "WinT Messenger"
}

# Import C++ code
HEADERS += \
    src/bridge.h \
    src/device_manager.h \
    src/settings.h \
    src/chat/chat.h \
    src/chat/client.h \
    src/chat/connection.h \
    src/chat/peermanager.h \
    src/chat/server.h \
    src/updater.h

SOURCES += \
    src/main.cpp \
    src/chat/chat.cpp \
    src/chat/client.cpp \
    src/chat/connection.cpp \
    src/chat/peermanager.cpp \
    src/chat/server.cpp \
    src/bridge.cpp \
    src/device_manager.cpp \
    src/settings.cpp \
    src/updater.cpp

# Import resources
RESOURCES += \
    res/res.qrc \
    qml/qml.qrc

# Import QML Files for easy editing
OTHER_FILES += \
    qml/*.qml \
    qml/*.js \
    qml/controls/*.qml \
    qml/pages/*.qml
