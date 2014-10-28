#
#  This file is part of WinT Messenger
#
#  Copyright (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

TEMPLATE = lib
CONFIG += c++11
CONFIG += shared
QT += core xml network
DEFINES += XMPP_LIBRARY

win32 {
    DESTDIR = $$OUT_PWD
}

macx {
    CONFIG += static
}

LIBS += -L$$OUT_PWD/../qxmpp -lqxmpp

SOURCES += $$PWD/src/xmpp.cpp
HEADERS += $$PWD/src/xmpp.h $$PWD/src/xmpp_global.h $$PWD/src/Xmpp

INCLUDEPATH += $$PWD/../qxmpp/src/base \
               $$PWD/../qxmpp/src/client \
               $$PWD/../qxmpp/src/server
