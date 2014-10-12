#
#  This file is part of WinT Messenger
#
#  Copyright (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

TEMPLATE = lib
CONFIG += shared
QT += core network
DEFINES += QCHAT_LIBRARY

win32 {
    DESTDIR = $$OUT_PWD
}

HEADERS += \
    $$PWD/src/qchat.h \
    $$PWD/src/client.h \
    $$PWD/src/peermanager.h \
    $$PWD/src/qchat_global.h \
    $$PWD/src/file-connection/f_server.h \
    $$PWD/src/message-connection/m_server.h \
    $$PWD/src/file-connection/f_connection.h \
    $$PWD/src/message-connection/m_connection.h \
    $$PWD/src/QChat

SOURCES += \
    $$PWD/src/qchat.cpp \
    $$PWD/src/client.cpp \
    $$PWD/src/peermanager.cpp \
    $$PWD/src/file-connection/f_server.cpp \
    $$PWD/src/message-connection/m_server.cpp \
    $$PWD/src/file-connection/f_connection.cpp \
    $$PWD/src/message-connection/m_connection.cpp
