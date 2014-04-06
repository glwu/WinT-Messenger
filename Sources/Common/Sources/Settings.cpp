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

bool Settings::firstLaunch() {
    return settings->value("firstLaunch", true).toBool();
}

bool Settings::customizedUiColor() {
    return settings->value("customizedUiColor", true).toBool();
}

bool Settings::opaqueToolbar() {
    return settings->value("opaqueToolbar", false).toBool();
}

void Settings::saveX(int x) {
    setValue("x", x);
}

void Settings::saveY(int y) {
    setValue("y", y);
}

void Settings::saveWidth(int width) {
    setValue("width", width);
}

void Settings::saveHeight(int height) {
    setValue("height", height);
}
