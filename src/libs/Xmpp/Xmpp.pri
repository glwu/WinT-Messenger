#
#  This file is part of WinT Messenger
#
#  Copyright (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
#
#  Please check the license.txt file for more information.
#

CONFIG += c++11

LIBS += -L$$OUT_PWD/../libs/QXmpp -lqxmpp

SOURCES += $$PWD/src/xmpp.cpp
HEADERS += $$PWD/src/xmpp.h

OTHER_FILES += $$PWD/src/Xmpp

INCLUDEPATH += $$PWD/src \
               $$PWD/../QXmpp/src/base \
               $$PWD/../QXmpp/src/client \
               $$PWD/../QXmpp/src/server
