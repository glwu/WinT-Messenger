//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QApplication>
#include <QQmlComponent>

#include "bridge.h"
#include "settings.h"
#include "app_info.h"

int main (int argc, char *argv[])
{
    QApplication app (argc, argv);
    app.setApplicationName(APP_NAME);
    app.setApplicationVersion(APP_VERSION);

    Bridge bridge;
    Settings settings;

    QDir emojiDir (":/smileys/smileys/");
    QStringList emojiList = emojiDir.entryList (QStringList ("*.png"));

    QDir facesDir (":/faces/faces/");
    QStringList facesList = facesDir.entryList (QStringList ("*.jpg")) +
            facesDir.entryList (QStringList ("*.png"));

    QQmlEngine *engine = new QQmlEngine();
    QQmlComponent *component = new QQmlComponent (engine);

    engine->rootContext()->setContextProperty ("bridge", &bridge);
    engine->rootContext()->setContextProperty ("settings", &settings);
    engine->rootContext()->setContextProperty ("device", &bridge.manager);
    engine->rootContext()->setContextProperty ("facesList", QVariant::fromValue (facesList));
    engine->rootContext()->setContextProperty ("emojiList", QVariant::fromValue (emojiList));

    engine->rootContext()->setContextProperty ("appName", APP_NAME);
    engine->rootContext()->setContextProperty ("appCompany", APP_COMPANY);
    engine->rootContext()->setContextProperty ("appVersion", APP_VERSION);

    engine->addImageProvider ("profile-pictures", bridge.imageProvider);

    component->loadUrl (QUrl ("qrc:/qml/qml/main.qml"));
    QQuickWindow *window = qobject_cast<QQuickWindow *> (component->create());

    MOBILE_TARGET ? window->showMaximized() : window->showNormal();

    return app.exec();
}
