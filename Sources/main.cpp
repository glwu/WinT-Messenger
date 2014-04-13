//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include <QQmlContext>
#include <QApplication>
#include <QQuickWindow>
#include <QQmlComponent>
#include <QFontDatabase>
#include <QQmlApplicationEngine>

#include "Common/Headers/Bridge.h"
#include "Common/Headers/Settings.h"
#include "Common/Headers/DeviceManager.h"

int main(int argc, char **argv) {
    QNetworkProxyFactory::setUseSystemConfiguration(true);
    QApplication app(argc, argv);

    Bridge *bridge = new Bridge();
    Settings *settings = new Settings();
    DeviceManager *manager = new DeviceManager();

    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->rootContext()->setContextProperty("Settings", settings);
    engine->rootContext()->setContextProperty("Bridge",   bridge);
    engine->rootContext()->setContextProperty("DeviceManager",  manager);

    QQmlComponent *component = new QQmlComponent(engine);
    component->loadUrl(QUrl("qrc:/QML/main.qml"));

    QObject *object = component->create();
    QQuickWindow *window = qobject_cast<QQuickWindow *>(object);

    window->show();

    return app.exec();
}
