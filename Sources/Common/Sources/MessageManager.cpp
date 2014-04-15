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

QString MessageManager::addEmotes(QString msg, int size) {
    QString path = "&nbsp;<img src = \"qrc:/emotes/";
    QString end = QString(".png\" width=%1 height=%1>&nbsp;").arg(size);

    msg.replace("x-(",  "*ANGRY*");
    msg.replace(":-)",  "*SMILE*");
    msg.replace("B-)",  "*COOL*");
    msg.replace(":'(",  "*CRYING*");
    msg.replace(">:-)", "*DEVIL*");
    msg.replace(":->",  "*GRIN*");
    msg.replace("=)",   "*HAPPY*");
    msg.replace("<3",   "*HEART*");
    msg.replace(":-*",  "*KISSING*");
    msg.replace("=D",   "*LOL*");
    msg.replace(":-[",  "*POUTY*");
    msg.replace(":-(",  "*SAD*");
    msg.replace(":-&",  "*SICK*");
    msg.replace(":-O",  "*SURPRISED*");
    msg.replace("x-|",  "*PINCHED*");
    msg.replace(":-P",  "*TONGUE*");
    msg.replace(":-?",  "*UNCERTAIN*");
    msg.replace(";-)",  "*WINK*");

    msg.replace("x(",  "*ANGRY*");
    msg.replace("B)",  "*COOL*");
    msg.replace(">:)", "*DEVIL*");
    msg.replace(":>",  "*GRIN*");
    msg.replace("=)",  "*HAPPY*");
    msg.replace("<3",  "*HEART*");
    msg.replace("=D",  "*LOL*");
    msg.replace(":[",  "*POUTY*");
    msg.replace(":(",  "*SAD*");
    msg.replace(":&",  "*SICK*");
    msg.replace(":)",  "*SMILE*");
    msg.replace(":O",  "*SURPRISED*");
    msg.replace("x|",  "*PINCHED*");
    msg.replace(":P",  "*TONGUE*");
    msg.replace(":?",  "*UNCERTAIN*");
    msg.replace(";)",  "*WINK*");

    msg.replace("^_^",   "*JOYFUL*");
    msg.replace("(.V.)", "*ALIEN*");
    msg.replace("-_-",   "*SLEEPING*");
    msg.replace("o.o?",  "*WONDERING*");

    msg.replace("*ALIEN*",     path + "alien"     + end);
    msg.replace("*ANGEL*",     path + "angel"     + end);
    msg.replace("*ANGRY*",     path + "angry"     + end);
    msg.replace("*COOL*",      path + "cool"      + end);
    msg.replace("*CRYING*",    path + "crying"    + end);
    msg.replace("*DEVIL*",     path + "devil"     + end);
    msg.replace("*GRIN*",      path + "grin"      + end);
    msg.replace("*HAPPY*",     path + "happy"     + end);
    msg.replace("*HEART*",     path + "heart"     + end);
    msg.replace("*JOYFUL*",    path + "joyful"    + end);
    msg.replace("*KISSING*",   path + "kissing"   + end);
    msg.replace("*LOL*",       path + "lol"       + end);
    msg.replace("*POUTY*",     path + "pouty"     + end);
    msg.replace("*SAD*",       path + "sad"       + end);
    msg.replace("*SICK*",      path + "sick"      + end);
    msg.replace("*SLEEPING*",  path + "sleeping"  + end);
    msg.replace("*SMILE*",     path + "smile"     + end);
    msg.replace("*PINCHED*",   path + "pinched"   + end);
    msg.replace("*TONGUE*",    path + "tongue"    + end);
    msg.replace("*UNCERTAIN*", path + "unsure"    + end);
    msg.replace("*WINK*",      path + "wink"      + end);
    msg.replace("*WONDERING*", path + "wondering" + end);
    return msg;
}
