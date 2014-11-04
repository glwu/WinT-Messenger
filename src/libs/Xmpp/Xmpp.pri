#
#  This file is part of WinT Messenger
#
#  Copyright (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

CONFIG += c++11

LIBS += -L$$OUT_PWD/../libs/qxmpp -lqxmpp

SOURCES += $$PWD/src/xmpp.cpp
HEADERS += $$PWD/src/xmpp.h

OTHER_FILES += $$PWD/src/Xmpp

INCLUDEPATH += $$PWD/src \
               $$PWD/../qxmpp/src/base \
               $$PWD/../qxmpp/src/client \
               $$PWD/../qxmpp/src/server