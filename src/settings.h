//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QScreen>
#include <QSettings>
#include <QGuiApplication>

class Settings : public QObject {

    Q_OBJECT

public:
    Settings();

    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue) const;

    Q_INVOKABLE int x();
    Q_INVOKABLE int y();
    Q_INVOKABLE int width();
    Q_INVOKABLE int height();
    Q_INVOKABLE bool maximized();
    Q_INVOKABLE bool fullscreen();
    Q_INVOKABLE bool firstLaunch();
    Q_INVOKABLE bool darkInterface();
    Q_INVOKABLE bool notifyUpdates();
    Q_INVOKABLE bool soundsEnabled();

private:
    QSettings* settings;
};

#endif
