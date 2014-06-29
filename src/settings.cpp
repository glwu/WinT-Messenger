//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "settings.h"

/*!
 * \brief Settings::Settings
 *
 * Creates a new QSettings object with:
 *  - Company name as "WinT 3794"
 *  - Program name as "WinT Messenger"
 */

Settings::Settings() {
    settings = new QSettings("WinT 3794", "WinT Messenger");
}

/*!
 * \brief Settings::setValue
 * \param key
 * \param value
 *
 * Changes the value of the \c key parameter with the \c value paramenter.
 */

void Settings::setValue(const QString &key, const QVariant &value) {
    settings->setValue(key, value);
}

/*!
 * \brief Settings::value
 * \param key
 * \param defaultValue
 * \return
 *
 * Returns the value of the \c key parameter and defines the default value of
 * the key with the \c defaultValue parameter.
 */

QVariant Settings::value(const QString &key, const QVariant &defaultValue) const {
    return settings->value(key, defaultValue);
}

/*!
 * \brief Settings::x
 * \return
 *
 * Returns the value of "x" under desktop operating systems.
 */

int Settings::x() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return 0;
#else
    return settings->value("x", 150).toInt();
#endif
}

/*!
 * \brief Settings::y
 * \return
 *
 * Returns the value of "y" under desktop operating systems.
 */

int Settings::y() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return 0;
#else
    return settings->value("y", 150).toInt();
#endif
}

/*!
 * \brief Settings::width
 * \return
 *
 * Returns the value of "width" under desktop operating systems.
 */

int Settings::width() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return qApp->primaryScreen()->geometry().width();
#else
    return settings->value("width", 720).toInt();
#endif
}

/*!
 * \brief Settings::height
 * \return
 *
 * Returns the value of "height" under desktop operating systems.
 */

int Settings::height() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return qApp->primaryScreen()->geometry().width();
#else
    return settings->value("height", 540).toInt();
#endif
}

/*!
 * \brief Settings::textChat
 * \return
 *
 * Returns the value of "textChat".
 */

bool Settings::textChat() {
    return settings->value("textChat", false).toBool();
}

/*!
 * \brief Settings::maximized
 * \return
 *
 * Returns the value of "maximized".
 */

bool Settings::maximized() {
    return settings->value("maximized", false).toBool();
}

/*!
 * \brief Settings::fullscreen
 * \return
 *
 * Returns the value of "fullscreen".
 */

bool Settings::fullscreen() {
    return settings->value("fullscreen", false).toBool();
}

/*!
 * \brief Settings::customColor
 * \return
 *
 * Returns the value of "customColor".
 */

bool Settings::customColor() {
    return settings->value("customColor", false).toBool();
}

/*!
 * \brief Settings::firstLaunch
 * \return
 *
 * Returns the value of "firstLaunch".
 */

bool Settings::firstLaunch() {
    return settings->value("firstLaunch", true).toBool();
}

/*!
 * \brief Settings::darkInterface
 * \return
 *
 * Returns the value of "darkInterface".
 */

bool Settings::darkInterface() {
    return settings->value("darkInterface", false).toBool();
}

/*!
 * \brief Settings::notifyUpdates
 * \return
 *
 * Returns the value of "notifyUpdates"
 */

bool Settings::notifyUpdates() {
    return settings->value("notifyUpdates", true).toBool();
}

/*!
 * \brief Settings::soundsEnabled
 * \return
 *
 * Returns the value of "soundsEnabled".
 */

bool Settings::soundsEnabled() {
    return settings->value("soundsEnabled", true).toBool();
}
