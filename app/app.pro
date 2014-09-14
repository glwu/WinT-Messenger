#
#  This file is part of WinT Messenger
#
#  Copyright (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

# Set app data
TEMPLATE = app
TARGET = wint-messenger

# Pre-compile QML code
CONFIG += qtquickcompiler

# Use C++ 11 or die
CONFIG += c++11

# Include paths
INCLUDEPATH += src
INCLUDEPATH += ../libs/xmpp/src
INCLUDEPATH += ../libs/qchat/src
INCLUDEPATH += ../libs/xmpp/qxmpp/src/base
INCLUDEPATH += ../libs/xmpp/qxmpp/src/client
INCLUDEPATH += ../libs/xmpp/qxmpp/src/server

# Include libraries
LIBS += -L../libs/xmpp/ -lxmpp
LIBS += -L../libs/qchat/ -lqchat
LIBS += -L../libs/xmpp/qxmpp/src -lqxmpp

# Include Qt Modules
QT += svg
QT += xml
QT += gui
QT += qml
QT += quick
QT += widgets
QT += multimedia

# Add the resources
RESOURCES += $$PWD/res/res.qrc

# Config for Mac
macx {
    CONFIG += app_bundle
    LIBS += -lcrypto -lssl
    TARGET = "WinT Messenger"
    ICON = ../sys/mac/icon.icns
    RC_FILE = ../sys/mac/info.plist
    QMAKE_INFO_PLIST = ../sys/mac/info.plist
}

# Config for Linux
linux:!android {
    LIBS += -lcrypto -lssl
    target.path    = /usr/bin
    desktop.path   = /usr/share/applications
    desktop.files += ../sys/linux/wint-messenger.desktop
    INSTALLS      += target desktop
}

# Config for Windows
win32* {

}

# Config for Android
android {
    ANDROID_PACKAGE_SOURCE_DIR = ../sys/android/
}

# Config for iOS
ios {
    ICONS.files = ../sys/ios/icon.png
    QMAKE_INFO_PLIST = ../sys/ios/info.plist
    QMAKE_BUNDLE_DATA += ICONS
}

# Import headers
HEADERS += \
    src/bridge.h \
    src/updater.h \
    src/settings.h \
    src/app_info.h \
    src/device_manager.h \
    src/image_provider.h \
    src/platforms.h

# Import sources
SOURCES += \
    src/main.cpp \
    src/bridge.cpp \
    src/updater.cpp \
    src/settings.cpp \
    src/device_manager.cpp \
    src/image_provider.cpp

# Extra config for iOS
ios {
    HEADERS -= src/updater.h
    SOURCES -= src/updater.cpp
}
