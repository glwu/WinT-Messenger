//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "settings.h"

Settings::Settings()
{
    m_primary_color = "#2672AC";
    m_settings = new QSettings (COMPANY_NAME, APP_NAME);
}

void Settings::setValue (QString key, QVariant value)
{
    m_settings->setValue (key, value);
}

QVariant Settings::value (QString key, QVariant defaultValue) const
{
    return m_settings->value (key, defaultValue);
}

int Settings::x()
{
    return value ("x", 150).toInt();
}

int Settings::y()
{
    return value ("x", 150).toInt();
}

int Settings::width()
{
    return value ("width", 860).toInt();
}

int Settings::height()
{
    return value ("height", 560).toInt();
}

bool Settings::textChat()
{
    return value ("textChat", false).toBool();
}

bool Settings::customColor()
{
    return value ("customColor", true).toBool();
}

bool Settings::firstLaunch()
{
    return value ("firstLaunch", true).toBool();
}

bool Settings::notifyUpdates()
{
    return value ("notifyUpdates", true).toBool();
}

bool Settings::soundsEnabled()
{
    return value ("soundsEnabled", true).toBool();
}

QString Settings::primaryColor()
{
    return value ("primaryColor", m_primary_color).toString();
}
