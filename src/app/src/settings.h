//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QPalette>
#include <QScreen>
#include <QSettings>
#include <QApplication>

#include "app_info.h"

class Settings : public QObject
{
        Q_OBJECT

    public:
        Settings();

        Q_INVOKABLE void setValue (QString key, QVariant value);
        Q_INVOKABLE QVariant value (QString key, QVariant defaultValue) const;

        Q_INVOKABLE int x();
        Q_INVOKABLE int y();
        Q_INVOKABLE int width();
        Q_INVOKABLE int height();
        Q_INVOKABLE bool textChat();
        Q_INVOKABLE bool customColor();
        Q_INVOKABLE bool firstLaunch();
        Q_INVOKABLE bool notifyUpdates();
        Q_INVOKABLE bool soundsEnabled();
        Q_INVOKABLE QString primaryColor();

    private:

        QSettings *m_settings;
        QString m_primary_color;
};

#endif
