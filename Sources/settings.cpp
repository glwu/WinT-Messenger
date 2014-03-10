#include "settings.h"

Settings::Settings() {
    settings = new QSettings("WinT 3794", "WinT IM");
}

void Settings::setValue(const QString &key, const QVariant &value) {
    settings->setValue(key, value);
}

QVariant Settings::value(const QString &key, const QVariant &defaultValue) const {
    return settings->value(key, defaultValue);
}
