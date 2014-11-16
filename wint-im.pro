#
#  This file is part of WinT Messenger
#
#  Copyright (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

CONFIG += ordered
TEMPLATE = subdirs

SUBDIRS += $$PWD/src/libs/QXmpp
SUBDIRS += $$PWD/src/app

OTHER_FILES += $$PWD/src/app/res/qml/*.qml
OTHER_FILES += $$PWD/src/app/res/qml/chat/*.qml
OTHER_FILES += $$PWD/src/app/res/qml/controls/*.qml
OTHER_FILES += $$PWD/src/app/res/qml/core/*.qml
OTHER_FILES += $$PWD/src/app/res/qml/dialogs/*.qml
OTHER_FILES += $$PWD/src/app/res/qml/menus/*.qml
OTHER_FILES += $$PWD/src/app/res/qml/pages/*.qml


