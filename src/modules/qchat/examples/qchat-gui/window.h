//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#ifndef WINDOW_H
#define WINDOW_H

#include "ui_window.h"

#include <qchat.h>
#include <qdialog.h>
#include <qfiledialog.h>
#include <qinputdialog.h>

namespace Ui {class Window;}

class Window : public QDialog {

    Q_OBJECT

public:
    explicit Window(QWidget* parent = 0);
    ~Window();

private slots:
    void shareFiles();
    void returnPressed();
    void removeUser(QString nick);
    void newUser(QString nick, QString face);
    void downloadComplete(QString peer_address, QString f_name);
    void newDownload(QString peer_address, QString f_name, int f_size);
    void newMessage(QString from, QString face, QString message, QString color, char localUser);

private:
    QChat* qChat;
    QString nick;
    Ui::Window* ui;
};

#endif
