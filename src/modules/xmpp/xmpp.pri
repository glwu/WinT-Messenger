#
#  This file is part of WinT Messenger
#
#  Copytight (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

QT -= gui
QT += xml
QT += network

QXMPP_LIBRARY_TYPE=staticlib

INCLUDEPATH += \
    $$PWD/lib-qxmpp/base \
    $$PWD/lib-qxmpp/client \
    $$PWD/lib-qxmpp/server

HEADERS += \
    $$PWD/src/*.h \
    $$PWD/lib-qxmpp/base/*.h \
    $$PWD/lib-qxmpp/client/*.h \
    $$PWD/lib-qxmpp/server/*.h
   
SOURCES += \
    $$PWD/src/*.cpp \
    $$PWD/lib-qxmpp/base/*.cpp \
    $$PWD/lib-qxmpp/client/*.cpp \
    $$PWD/lib-qxmpp/server/*.cpp
