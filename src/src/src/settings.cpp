//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "settings.h"

/// Creates a new QSettings object with:
/// - Company name as "WinT 3794"
/// - Program name as "WinT Messenger"
Settings::Settings() {
    settings = new QSettings("WinT 3794", "WinT Messenger");
}

/// Changes the value of the \c key parameter with the \c value parameter
///
/// \param key the value to change
/// \param value the new value to write
void Settings::setValue(QString key, QVariant value) {
    settings->setValue(key, value);
}

/// Returns the value of the \c key parameter and defines the default value of
/// the key with the \c defaultValue parameter.
///
/// \param key the key value to read
/// \param defaultValue the default value of the selected key
QVariant Settings::value(QString key, QVariant defaultValue) const {
    return settings->value(key, defaultValue);
}

/// OTHER FUNCTIONS
/// ==============================================================================
/// These functions are used by the QML interface. We included all booleans here
/// because the QML interface has (as of Qt 5.2.1) trouble converting a QVariant
/// into a boolean.

int Settings::x() {
#ifdef MOBILE_TARGET
    return 0;
#else
    return value("x", 150).toInt();
#endif
}

int Settings::y() {
#ifdef MOBILE_TARGET
    return 0;
#else
    return value("y", 150).toInt();
#endif
}

int Settings::width() {
#ifdef MOBILE_TARGET
    return 0;
#else
    return value("width", 720).toInt();
#endif
}

int Settings::height() {
#ifdef MOBILE_TARGET
    return 0;
#else
    return value("height", 540).toInt();
#endif
}

bool Settings::textChat() {
    return value("textChat", false).toBool();
}

bool Settings::customColor() {
    return value("customColor", true).toBool();
}

bool Settings::firstLaunch() {
    return value("firstLaunch", true).toBool();
}

bool Settings::darkInterface() {
    return value("darkInterface", false).toBool();
}

bool Settings::notifyUpdates() {
    return value("notifyUpdates", true).toBool();
}

bool Settings::soundsEnabled() {
    return value("soundsEnabled", true).toBool();
}
