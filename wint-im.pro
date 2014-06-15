# Copyright (C) 2014 the WinT Team
# Please License.txt and the Authors.txt files for more information

TARGET   = wint-messenger
TEMPLATE = app
VERSION = 1.2.0

CODECFORTR  = UTF-8
CODECFORSRC = UTF-8

QT += gui
QT += qml
QT += svg
QT += core
QT += quick
QT += widgets
QT += network

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

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/sys/android
}

ios {
    QMAKE_INFO_PLIST   = sys/ios/info.plist
    ICONS.files = $$PWD/sys/ios/icon.png
    FONTS.files = $$PWD/res/fonts/regular.ttf
    QMAKE_BUNDLE_DATA += FONTS
    QMAKE_BUNDLE_DATA += ICONS
    HEADERS -= src/updater.h
    SOURCES -= src/updater.cpp
}

win32* {
    RC_FILE = sys/windows/manifest.rc
    TARGET = "WinT Messenger"
}

macx {
    QMAKE_INFO_PLIST = sys/mac/info.plist
    RC_FILE = sys/mac/info.plist
    LIBS += -lcrypto -lssl
    ICON = sys/mac/icon.icns
    CONFIG += app_bundle
    TARGET = "WinT Messenger"
}

RESOURCES += \
    res/res.qrc \
    qml/qml.qrc

OTHER_FILES += \
    qml/*.qml \
    qml/controls/*.qml \
    qml/pages/*.qml
