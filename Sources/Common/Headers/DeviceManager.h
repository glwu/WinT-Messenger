#ifndef DEVICE_MANAGER_H
#define DEVICE_MANAGER_H

#include <QScreen>
#include <QObject>
#include <QScreen>
#include <QSettings>
#include <QApplication>

class DeviceManager : public QObject {
    Q_OBJECT

public:
    Q_INVOKABLE bool isMobile();
    Q_INVOKABLE int ratio(int input);
};

#endif

