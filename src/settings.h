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

/*==============================================================================*
 * What does this class do?                                                     *
 *------------------------------------------------------------------------------*
 * This class allows the QML interface to access the program's settings in a    *
 * reliable way. You may notice a lot of booleans here, I implemented those     *
 * functions because the QML interface could not convert a QVariant into a bool *
 * in Microsoft Windows (at least with Qt 5.2.1).                               *
 *==============================================================================*/


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

private:
    QSettings* settings;
};

#endif
