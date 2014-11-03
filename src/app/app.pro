#
#  This file is part of WinT Messenger
#
#  Copyright (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

TEMPLATE = app
CONFIG += c++11
TARGET = wint-messenger
CONFIG += qtquickcompiler

include($$PWD/../libs/Xmpp/Xmpp.pri)
include($$PWD/../libs/QChat/QChat.pri)
include($$PWD/../libs/QSimpleUpdater/QSimpleUpdater.pri)

LIBS += -L$$OUT_PWD/../libs/QXmpp -lqxmpp
QT += svg xml gui qml quick widgets multimedia

HEADERS += $$PWD/src/*.h
SOURCES += $$PWD/src/*.cpp
RESOURCES += $$PWD/res/res.qrc

OTHER_FILES += $$PWD/res/qml/*.qml
OTHER_FILES += $$PWD/res/qml/chat/*.qml
OTHER_FILES += $$PWD/res/qml/controls/*.qml
OTHER_FILES += $$PWD/res/qml/core/*.qml
OTHER_FILES += $$PWD/res/qml/dialogs/*.qml
OTHER_FILES += $$PWD/res/qml/menus/*.qml

macx {
    TARGET = "WinT Messenger"
    ICON = $$PWD/../../data/mac/icon.icns
    RC_FILE = $$PWD/../../data/mac/info.plist
    QMAKE_INFO_PLIST = $$PWD/../../data/mac/info.plist
}

linux:!android {
    target.path    = /usr/bin
    desktop.path   = /usr/share/applications
    desktop.files += $$PWD/../../data/linux/wint-messenger.desktop
    INSTALLS      += target desktop
}

win32* {
    TARGET = "WinT Messenger"
    RC_FILE = $$PWD/../../data/windows/manifest.rc
}

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/../../data/android/
}

ios {
    ICONS.files = $$PWD/../../data/ios/icon.png
    QMAKE_INFO_PLIST = $$PWD/../../data/ios/info.plist
    QMAKE_BUNDLE_DATA += ICONS
    HEADERS -=
    SOURCES -=
}
