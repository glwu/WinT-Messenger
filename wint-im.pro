#
#  This file is part of WinT Messenger
#
#  Copytight (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

TARGET   = wint-messenger
TEMPLATE = app
VERSION  = 1.3.1

CODECFORTR  = UTF-8
CODECFORSRC = UTF-8

CONFIG += c++11

QT += gui
QT += qml
QT += sql
QT += svg
QT += xml
QT += core
QT += quick
QT += widgets
QT += network
QT += multimedia

HEADERS += \
    src/bridge.h \
    src/device_manager.h \
    src/settings.h \
    src/chat/chat.h \
    src/chat/client.h \
    src/chat/peermanager.h \
    src/updater.h \
    src/chat/file-connection/f_connection.h \
    src/chat/file-connection/f_server.h \
    src/chat/message-connection/m_server.h \
    src/chat/message-connection/m_connection.h

SOURCES += \
    src/main.cpp \
    src/chat/chat.cpp \
    src/chat/client.cpp \
    src/chat/peermanager.cpp \
    src/bridge.cpp \
    src/device_manager.cpp \
    src/settings.cpp \
    src/updater.cpp \
    src/chat/file-connection/f_connection.cpp \
    src/chat/file-connection/f_server.cpp \
    src/chat/message-connection/m_connection.cpp \
    src/chat/message-connection/m_server.cpp

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

iphonesimulator {
    QMAKE_INFO_PLIST   = sys/ios/info.plist
    ICONS.files = $$PWD/sys/ios/icon.png
    FONTS.files = $$PWD/res/fonts/regular.ttf
    QMAKE_BUNDLE_DATA += FONTS
    QMAKE_BUNDLE_DATA += ICONS

    HEADERS -= src/updater.h
    SOURCES -= src/updater.cpp
}

win32* {
    LIBS += -L"C:/OpenSSL-Win32/lib" -llibeay32
    CONFIG += openssl-linked
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
    qml/controls/ListItems/*.qml
