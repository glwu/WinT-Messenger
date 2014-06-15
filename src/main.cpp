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

/*==============================================================================*
 * Welcome to the code! (if there's a better way to say it, please tell me)     *
 *------------------------------------------------------------------------------*
 * You will find a comment on the beggining of the declaration of each class    *
 * (in the header files) that explains what does that specific class do.        *
 * On the other hand, the source files will seldomly contain comments.          *
 *                                                                              *
 * If you are trying to compile this program under Linux, you may get an error  *
 * similar to "peerManager.h" not found in the file client.h, around line 11.   *
 * If so, simply change "peerManager.h" to "peermanager.h" and everything       *
 * should work fine. Also, you will need to have the mesa-common-dev package    *
 * installed in order to avoid the fatal error of "GL/gl.h missing".            *
 *                                                                              *
 * Suggestions are always welcome, send me an email to alex.racotta@gmail.com   *
 * or post something at the mailing lists:                                      *
 * https://groups.google.com/forum/#!forum/wint-messenger-developers            *
 *                                                                              *
 * Greetings!                                                                   *
 *==============================================================================*/

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
    window->setDefaultAlphaBuffer(true);
    window->setScreen(app.primaryScreen());

    if (device.isMobile())
        window->showFullScreen();

    else {
        if (settings.fullscreen())
            window->showFullScreen();
        else if (settings.maximized())
            window->showMaximized();
        else
            window->showNormal();
    }

    return app.exec();
}
