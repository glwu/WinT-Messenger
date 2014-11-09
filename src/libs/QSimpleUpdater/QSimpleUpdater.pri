#
#  This file is part of QSimpleUpdater
#
#  Copyright (c) 2014 Alex Spataru <alex_spataru@outlook.com>
#
#  Please check the license.txt file for more information.
#

QT += gui
QT += widgets
QT += network

HEADERS += $$PWD/src/qsimpleupdater.h \
    $$PWD/src/dialogs/download_dialog.h
SOURCES += $$PWD/src/qsimpleupdater.cpp \
    $$PWD/src/dialogs/download_dialog.cpp
OTHER_FILES += $$PWD/src/QSimpleUpdater

INCLUDEPATH += $$PWD/src

macx || linux{
    LIBS += -lcrypto -lssl
}

win32* {
    CONFIG += openssl-linked
    LIBS += -L$$PWD/dependencies/win32/ -llibeay32
}

RESOURCES += $$PWD/res/qsu_resources.qrc

FORMS += \
    $$PWD/src/dialogs/download_dialog.ui
