#
#  This file is part of WinT Messenger
#
#  Copytight (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

QT += svg
QT += xml
QT += gui
QT += qml
QT += quick
QT += widgets
QT += multimedia

TARGET = wint-messenger

INCLUDEPATH += \
    $$PWD/modules/xmpp/src \
    $$PWD/modules/qchat/src

include(modules/xmpp/xmpp.pri)
include(modules/qchat/qchat.pri)

HEADERS += \
    src/src/bridge.h \
    src/src/updater.h \
    src/src/settings.h \
    src/src/device_manager.h

SOURCES += \
    src/main.cpp \
    src/src/bridge.cpp \
    src/src/updater.cpp \
    src/src/settings.cpp \
    src/src/device_manager.cpp

RESOURCES += \
    ../res/res.qrc \
    ../qml/qml.qrc

android {
    ANDROID_PACKAGE_SOURCE_DIR = ../sys/android
}

ios {
    QMAKE_BUNDLE_DATA += FONTS
    QMAKE_BUNDLE_DATA += ICONS
    HEADERS -= src/src/updater.h
    SOURCES -= src/src/updater.cpp
    ICONS.files = ../sys/ios/icon.png
    FONTS.files = ../res/fonts/regular.ttf
    QMAKE_INFO_PLIST = ../sys/ios/info.plist
}

win32* {
    CONFIG += openssl-linked
    TARGET = "WinT Messenger"
    RC_FILE = ../sys/windows/manifest.rc
    LIBS += -L"C:/OpenSSL-Win32/lib" -llibeay32
}

macx {
    CONFIG += app_bundle
    LIBS += -lcrypto -lssl
    TARGET = "WinT Messenger"
    ICON = ../sys/mac/icon.icns
    RC_FILE = ../sys/mac/info.plist
    QMAKE_INFO_PLIST = ../sys/mac/info.plist
}


