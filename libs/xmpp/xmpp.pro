#
#  This file is part of WinT Messenger
#
#  Copyright (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

TEMPLATE = lib
CONFIG += staticlib
LIBS += -L./qxmpp/src -lqxmpp

QT += xml
QT += core
QT += network

INCLUDEPATH += qxmpp/src/base
INCLUDEPATH += qxmpp/src/client
INCLUDEPATH += qxmpp/src/server

HEADERS += src/xmpp.h
SOURCES += src/xmpp.cpp
