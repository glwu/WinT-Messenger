//
//  This file is part of the WinT IM 1.0
//
//  Created on Dec. 18, 2013.
//  Copyright (c) 2013 WinT 3794. All rights reserved.
//

#include <QObject>
#include <QProcess>
#include <QQmlContext>
#include <QApplication>
#include <QQuickWindow>
#include <QQmlComponent>
#include <QQmlApplicationEngine>

#include "bridge.h"
#include "settings.h"

bool isMobile() {
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return true;
#else
    return false;
#endif
}

void setupWindow() {
    Bridge *bridge = new Bridge();
    Settings *settings = new Settings();

    bool mobile = isMobile();
    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->rootContext()->setContextProperty("settings", settings);
    engine->rootContext()->setContextProperty("bridge", bridge);
    engine->rootContext()->setContextProperty("isMobile", mobile);

    QObject::connect(engine, SIGNAL(quit()), qApp, SLOT(quit()));

    QQmlComponent *component = new QQmlComponent(engine);
    component->loadUrl(QUrl("qrc:/QML/main.qml"));

    QObject *object = component->create();

    QQuickWindow *window = qobject_cast<QQuickWindow *>(object);
    window->setMinimumSize(QSize(320, 480));

    if (!mobile) {
        window->resize(QSize(settings->value("width", 748).toInt(),
                             settings->value("height", 520).toInt()));

        window->setPosition(QPoint(settings->value("x", 150).toInt(),
                                   settings->value("y", 150).toInt()));

        QObject::connect(window, SIGNAL(widthChanged(int)),  settings, SLOT(saveWidth(int)));
        QObject::connect(window, SIGNAL(heightChanged(int)), settings, SLOT(saveHeight(int)));
        QObject::connect(window, SIGNAL(xChanged(int)),      settings, SLOT(saveX(int)));
        QObject::connect(window, SIGNAL(yChanged(int)),      settings, SLOT(saveY(int)));
    }

    window->show();
}

int main(int argc, char ** argv) {
    QApplication app(argc, argv);
    setupWindow();
    return app.exec();
}
