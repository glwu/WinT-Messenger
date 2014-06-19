//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QApplication>
#include <QQmlComponent>

#include "bridge.h"
#include "settings.h"
#include "device_manager.h"

/*!
 * \brief main
 * \param argc
 * \param argv
 * \return
 *
 * Creates a new \c QApplication, configures and loads the QML interface,
 * creates a new \c QQuickWindow to draw the QML interface and executes the \c qApp.
 */

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    Bridge bridge;
    Settings settings;
    DeviceManager device;

    QQmlEngine* engine = new QQmlEngine();
    QQmlComponent* component = new QQmlComponent(engine);
    QObject::connect(engine, SIGNAL(quit()), qApp, SLOT(quit()));

    engine->rootContext()->setContextProperty("bridge", &bridge);
    engine->rootContext()->setContextProperty("device", &device);
    engine->rootContext()->setContextProperty("settings", &settings);

    component->loadUrl(QUrl("qrc:/qml/main.qml"));
    QQuickWindow* window = qobject_cast<QQuickWindow*>(component->create());
    window->setScreen(app.primaryScreen());

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    window->showMaximized();
#else
    if (settings.fullscreen())
        window->showFullScreen();
    else if (settings.maximized())
        window->showMaximized();
    else
        window->showNormal();
#endif

    return app.exec();
}
