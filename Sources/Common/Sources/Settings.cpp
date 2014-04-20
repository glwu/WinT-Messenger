//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "../Headers/Settings.h"

Settings::Settings() {
    settings = new QSettings("WinT Messenger");
}

void Settings::setValue(const QString &key, const QVariant &value) {
    settings->setValue(key, value);
}

QVariant Settings::value(const QString &key, const QVariant &defaultValue) const {
    return settings->value(key, defaultValue);
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
    return qApp->primaryScreen()->geometry().height();
#else
    return settings->value("height", 540).toInt();
#endif
}

bool Settings::customizedUiColor() {
    return settings->value("customizedUiColor", true).toBool();
}

bool Settings::darkInterface() {
    return settings->value("darkInterface", false).toBool();
}

bool Settings::firstLaunch() {
    return settings->value("firstLaunch", true).toBool();
}

bool Settings::fullscreen() {
    return settings->value("fullscreen", false).toBool();
}

QString Settings::getDialogColor(const QString &originalColor) {
    QColorDialog dialog;
    dialog.setCurrentColor(QColor(originalColor));
    int ret = dialog.exec();

    if (ret == QColorDialog::Accepted)
        return dialog.selectedColor().name();

    return settings->value("userColor", "#0081bd").toString();
}
