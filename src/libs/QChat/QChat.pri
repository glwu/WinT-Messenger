#
#  This file is part of WinT Messenger
#
#  Copyright (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
#
#  Please check the license.txt file for more information.
#

QT += network
CONFIG += c++11

INCLUDEPATH += $$PWD/src
OTHER_FILES += $$PWD/src/QChat

HEADERS += \
    $$PWD/src/qchat.h \
    $$PWD/src/client.h \
    $$PWD/src/peermanager.h \
    $$PWD/src/qchat_global.h \
    $$PWD/src/file-connection/f_server.h \
    $$PWD/src/message-connection/m_server.h \
    $$PWD/src/file-connection/f_connection.h \
    $$PWD/src/message-connection/m_connection.h \

SOURCES += \
    $$PWD/src/qchat.cpp \
    $$PWD/src/client.cpp \
    $$PWD/src/peermanager.cpp \
    $$PWD/src/file-connection/f_server.cpp \
    $$PWD/src/message-connection/m_server.cpp \
    $$PWD/src/file-connection/f_connection.cpp \
    $$PWD/src/message-connection/m_connection.cpp
