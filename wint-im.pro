#
#  This file is part of WinT Messenger
#
#  Copytight (c) 2013-2014 WinT 3794
#  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
#
#  Please check the license.txt file for more information.
#

TEMPLATE = subdirs
CONFIG += ordered

SUBDIRS += libs/xmpp/qxmpp
SUBDIRS += libs/xmpp
SUBDIRS += libs/qchat
SUBDIRS += app

app.depends += libs/xmpp
app.depends += libs/qchat
xmpp.depends += libs/xmpp/qxmpp
