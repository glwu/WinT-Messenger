#include "emotes.h"

Emotes::Emotes() {}

QString Emotes::addEmotes(QString msg) {
    QString path = "&nbsp;<img src = 'qrc:/emotes/";
    QString end = ".png'>&nbsp;";

    msg.replace("x-(",  "*ANGRY*");
    msg.replace(":-)",  "*BANDIT*");
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
    msg.replace(":-)",  "*SMILE*");
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
    msg.replace("*PINCHED*",   path + "pinched" + end);
    msg.replace("*TONGUE*",    path + "tongue"    + end);
    msg.replace("*UNCERTAIN*", path + "unsure"    + end);
    msg.replace("*WINK*",      path + "wink"      + end);
    msg.replace("*WONDERING*", path + "wondering" + end);

    return msg;
}
