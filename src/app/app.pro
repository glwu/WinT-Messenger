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

INCLUDEPATH += $$PWD/src \
               $$PWD/../libs/xmpp/src \
               $$PWD/../libs/qchat/src \
               $$PWD/../libs/qxmpp/src/base \
               $$PWD/../libs/qxmpp/src/client \
               $$PWD/../libs/qxmpp/src/server

LIBS += -L$$OUT_PWD/../libs/qxmpp -lqxmpp \
        -L$$OUT_PWD/../libs/xmpp -lxmpp \
        -L$$OUT_PWD/../libs/qchat -lqchat

QT += svg \
      xml \
      gui \
      qml \
      quick \
      widgets \
      multimedia

HEADERS += $$PWD/src/*.h
SOURCES += $$PWD/src/*.cpp
RESOURCES += $$PWD/res/res.qrc

macx {
    CONFIG += app_bundle
    LIBS += -lcrypto -lssl
    TARGET = "WinT Messenger"
    ICON = $$PWD/../../data/mac/icon.icns
    RC_FILE = $$PWD/../../data/mac/info.plist
    QMAKE_INFO_PLIST = $$PWD/../../data/mac/info.plist
}

linux:!android {
    LIBS += -lcrypto -lssl
    target.path    = /usr/bin
    desktop.path   = /usr/share/applications
    desktop.files += $$PWD/../../data/linux/wint-messenger.desktop
    INSTALLS      += target desktop
}

win32* {
    CONFIG += openssl-linked
    TARGET = "WinT Messenger"
    RC_FILE = $$PWD/../../data/windows/manifest.rc
    LIBS += -L$$PWD/../../bin/3rd-party/win32/ -llibeay32
}

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/../../data/android/
}

ios {
    ICONS.files = $$PWD/../../data/ios/icon.png
    QMAKE_INFO_PLIST = $$PWD/../../data/ios/info.plist
    QMAKE_BUNDLE_DATA += ICONS
    HEADERS -= src/updater.h
    SOURCES -= src/updater.cpp
}


win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../libs/qchat/release/ -lqchat
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../libs/qchat/debug/ -lqchat
else:unix: LIBS += -L$$OUT_PWD/../libs/qchat/ -lqchat

INCLUDEPATH += $$PWD/../libs/qchat
DEPENDPATH += $$PWD/../libs/qchat
