#ifndef WINDOWLOADER_H
#define WINDOWLOADER_H

#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QQmlComponent>

#include "Bridge.h"
#include "Settings.h"
#include "DeviceManager.h"

class WindowLoader : public QObject {

    Q_OBJECT

public:
    void start();

private :
    QQmlEngine *engine;
    QQuickWindow *window;
    QQmlComponent *component;

    Bridge *bridge;
    Settings *settings;
    DeviceManager *deviceManager;
};

#endif
