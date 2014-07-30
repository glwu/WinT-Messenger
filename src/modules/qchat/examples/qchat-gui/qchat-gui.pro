#
#  This file is part of WinT Messenger
#
#  Copytight (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

QT += gui
QT += widgets

include(../../qchat.pri)

INCLUDEPATH = ../../src/

FORMS += \
    window.ui

HEADERS += \
    window.h

SOURCES += \
    main.cpp \
    window.cpp
