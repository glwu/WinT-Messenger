#ifndef DEVICE_MANAGER_H
#define DEVICE_MANAGER_H

#include <QObject>
#include <QScreen>
#include <QApplication>

class DeviceManager : public QObject {

    Q_OBJECT

public:
    Q_INVOKABLE static int ratio(int input);
};

#endif
