#include "settings.h"

Settings::Settings() {
    settings = new QSettings("WinT Messenger");
}

void Settings::setValue(const QString &key, const QVariant &value) {
    settings->setValue(key, value);
}

QVariant Settings::value(const QString &key, const QVariant &defaultValue) const {
    return settings->value(key, defaultValue);
}
