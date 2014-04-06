//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject {

    Q_OBJECT

public:
    Settings();

    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;

    Q_INVOKABLE bool firstLaunch();
    Q_INVOKABLE bool customizedUiColor();
    Q_INVOKABLE bool opaqueToolbar();

public slots:
    void saveX(int x);
    void saveY(int y);
    void saveWidth(int width);
    void saveHeight(int height);

private:
    QSettings *settings;
};

#endif
