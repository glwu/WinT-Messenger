#ifndef SETTINGS_H
#define SETTINGS_H

#include <QScreen>
#include <QSettings>
#include <QColorDialog>
#include <QApplication>

class Settings : public QObject {

    Q_OBJECT

public:
    Settings();

    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;

    Q_INVOKABLE int width();
    Q_INVOKABLE int height();

    Q_INVOKABLE bool customizedUiColor();
    Q_INVOKABLE bool darkInterface();
    Q_INVOKABLE bool firstLaunch();
    Q_INVOKABLE bool fullscreen();

    Q_INVOKABLE QString getDialogColor(const QString &originalColor);

private:
    QSettings *settings;
};

#endif
