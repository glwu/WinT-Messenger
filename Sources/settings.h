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

public slots:
    void saveWidth(int width) {
        setValue("width", width);
    }

    void saveHeight(int height) {
        setValue("height", height);
    }

    void saveX(int x) {
        setValue("x", x);
    }

    void saveY(int y) {
        setValue("y", y);
    }

private:
    QSettings *settings;
};

#endif
