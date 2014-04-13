//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#ifndef EMOTES_H
#define EMOTES_H

#include <QObject>
#include <QString>

class Emotes : public QObject {

    Q_OBJECT

public:
    Emotes();
    QString addEmotes(QString msg, int size);
};

#endif
