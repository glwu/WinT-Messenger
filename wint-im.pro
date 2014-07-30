#
#  This file is part of WinT Messenger
#
#  Copytight (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

VERSION  = 1.3.0
TEMPLATE = subdirs

CODECFORTR  = UTF-8
CODECFORSRC = UTF-8

CONFIG += c++11
CONFIG +=ordered

SUBDIRS += src

OTHER_FILES += \
    qml/*.qml \
    qml/controls/*.qml \
    qml/controls/Chat/*.qml \
    qml/controls/Core/*.qml \
    qml/controls/Dialogs/*.qml \
    qml/controls/Core/ListItems/*.qml

OTHER_FILES += \
    readme.md \
    license.txt \
    src/src/readme.md \
    src/modules/xmpp/readme.md \
    src/modules/qchat/readme.md
