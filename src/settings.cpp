//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "settings.h"

Settings::Settings() {
    settings = new QSettings("WinT 3794", "WinT Messenger");
}

void Settings::setValue(const QString &key, const QVariant &value) {
    settings->setValue(key, value);
}

QVariant Settings::value(const QString &key, const QVariant &defaultValue) const {
    return settings->value(key, defaultValue);
}

int Settings::x() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return 0;
#else
    return settings->value("x", 150).toInt();
#endif
}

int Settings::y() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return 0;
#else
    return settings->value("y", 150).toInt();
#endif
}

int Settings::width() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return qApp->primaryScreen()->geometry().width();
#else
    return settings->value("width", 720).toInt();
#endif
}

int Settings::height() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return qApp->primaryScreen()->geometry().width();
#else
    return settings->value("height", 540).toInt();
#endif
}

bool Settings::maximized() {
    return settings->value("maximized", false).toBool();
}

bool Settings::fullscreen() {
    return settings->value("fullscreen", false).toBool();
}

bool Settings::firstLaunch() {
    return settings->value("firstLaunch", true).toBool();
}

bool Settings::darkInterface() {
    return settings->value("darkInterface", false).toBool();
}

bool Settings::notifyUpdates() {
    return settings->value("notifyUpdates", true).toBool();
}
