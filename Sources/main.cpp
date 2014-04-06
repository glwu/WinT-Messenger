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
#include <QQmlApplicationEngine>

#include "Common/Headers/Bridge.h"
#include "Common/Headers/Settings.h"

bool isMobile() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return true;
#else
	return false;
#endif
}

void setupWindow() {
    Bridge *bridge = new Bridge();
    Settings *settings = new Settings();

    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->rootContext()->setContextProperty("settings", settings);
    engine->rootContext()->setContextProperty("bridge", bridge);
    engine->rootContext()->setContextProperty("mobile", isMobile());

    QQmlComponent *component = new QQmlComponent(engine);
    component->loadUrl(QUrl("qrc:/QML/main.qml"));

    QObject *object = component->create();
    QQuickWindow *window = qobject_cast<QQuickWindow *>(object);

    if (!isMobile()) {
        QObject::connect(window, SIGNAL(widthChanged(int)),  settings, SLOT(saveWidth(int)));
        QObject::connect(window, SIGNAL(heightChanged(int)), settings, SLOT(saveHeight(int)));
        QObject::connect(window, SIGNAL(xChanged(int)),      settings, SLOT(saveX(int)));
        QObject::connect(window, SIGNAL(yChanged(int)),      settings, SLOT(saveY(int)));

        window->setMinimumSize(QSize(320, 480));

        window->resize(QSize(settings->value("width", 748).toInt(),
                             settings->value("height", 520).toInt()));

        window->setPosition(QPoint(settings->value("x", 150).toInt(),
                                   settings->value("y", 150).toInt()));
    }

    window->show();
}

int main(int argc, char **argv) {
    QNetworkProxyFactory::setUseSystemConfiguration(true);

    QApplication app(argc, argv);
    setupWindow();
    return app.exec();
}
