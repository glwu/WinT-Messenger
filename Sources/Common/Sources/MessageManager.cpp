//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "../Headers/MessageManager.h"

QString MessageManager::formatMessage(const QString msg, const QString nick) {
    return "<font color = '"
            + QSettings("WinT Messenger").value("userColor", "#0081bd").toString()
            + "'>[" + QDateTime::currentDateTime().toString("hh:mm:ss AP") + "] "
            + "&lt;" + nick + "&gt;&nbsp; </font>"
            + msg;
}

QString MessageManager::formatNotification(const QString msg) {
    return "<font color = 'gray'>["
            + QDateTime::currentDateTime().toString("hh:mm:ss AP") + "]&nbsp;"
            + msg
            + "</font>";
}

QString MessageManager::addEmotes(QString msg) {
    QString path = "&nbsp;<img src = \"qrc:/emotes/";
    QString end = QString(".png\">&nbsp;");

    msg.replace("x-(",  "*angry*");
    msg.replace(":-)",  "*smile*");
    msg.replace("B-)",  "*cool*");
    msg.replace(":'(",  "*crying*");
    msg.replace(">:-)", "*devil*");
    msg.replace(":->",  "*grin*");
    msg.replace("=)",   "*happy*");
    msg.replace("<3",   "*heart*");
    msg.replace(":-*",  "*kissing*");
    msg.replace("=D",   "*lol*");
    msg.replace(":-[",  "*pouty*");
    msg.replace(":-(",  "*sad*");
    msg.replace(":-&",  "*sick*");
    msg.replace(":-O",  "*surprised*");
    msg.replace("x-|",  "*pinched*");
    msg.replace(":-P",  "*tongue*");
    msg.replace(":-?",  "*uncertain*");
    msg.replace(";-)",  "*wink*");
    msg.replace("x(",  "*angry*");
    msg.replace("B)",  "*cool*");
    msg.replace(">:)", "*devil*");
    msg.replace(":>",  "*grin*");
    msg.replace("=)",  "*happy*");
    msg.replace("<3",  "*heart*");
    msg.replace("=D",  "*lol*");
    msg.replace(":[",  "*pouty*");
    msg.replace(":(",  "*sad*");
    msg.replace(":&",  "*sick*");
    msg.replace(":)",  "*smile*");
    msg.replace(":O",  "*surprised*");
    msg.replace("x|",  "*pinched*");
    msg.replace(":P",  "*tongue*");
    msg.replace(":?",  "*uncertain*");
    msg.replace(";)",  "*wink*");
    msg.replace("^_^",   "*joyful*");
    msg.replace("(.V.)", "*alien*");
    msg.replace("-_-",   "*sleeping*");
    msg.replace("o.o?",  "*wondering*");

    msg.replace("*alien*",     path + "alien"     + end);
    msg.replace("*angel*",     path + "angel"     + end);
    msg.replace("*angry*",     path + "angry"     + end);
    msg.replace("*cool*",      path + "cool"      + end);
    msg.replace("*crying*",    path + "crying"    + end);
    msg.replace("*devil*",     path + "devil"     + end);
    msg.replace("*grin*",      path + "grin"      + end);
    msg.replace("*happy*",     path + "happy"     + end);
    msg.replace("*heart*",     path + "heart"     + end);
    msg.replace("*joyful*",    path + "joyful"    + end);
    msg.replace("*kissing*",   path + "kissing"   + end);
    msg.replace("*lol*",       path + "lol"       + end);
    msg.replace("*pouty*",     path + "pouty"     + end);
    msg.replace("*sad*",       path + "sad"       + end);
    msg.replace("*sick*",      path + "sick"      + end);
    msg.replace("*sleeping*",  path + "sleeping"  + end);
    msg.replace("*smile*",     path + "smile"     + end);
    msg.replace("*pinched*",   path + "pinched"   + end);
    msg.replace("*tongue*",    path + "tongue"    + end);
    msg.replace("*uncertain*", path + "unsure"    + end);
    msg.replace("*wink*",      path + "wink"      + end);
    msg.replace("*wondering*", path + "wondering" + end);

    return msg;
}
