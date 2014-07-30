//
//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include <qqmlengine.h>
#include <qqmlcontext.h>
#include <qquickwindow.h>
#include <qapplication.h>
#include <qqmlcomponent.h>

#include "src/bridge.h"
#include "src/settings.h"

/*!
 * \mainpage
 *
 * \section Introduction
 *
 * WinT Messenger is a practical instant messaging application that its
 * developed by a small team of students working in the
 * <a href="http://wint3794.org">WinT 3794 team</a>.
 * The application is written in QML/C++ and can be used with the most popular
 * desktop and mobile operating systems.
 * See the <a href="http://wint-im.sourceforge.net/features.html">features</a>
 * page for more information.
 *
 * You can see how the whole app works here, or write code to make it better!
 *
 * \section Contributing
 *
 *  - Join <a href="https://groups.google.com/forum/#!forum/wint-messenger">
 *  the mailing lists</a> to stay up to date with the development!.
 *  - Fork this project!
 *  - Make your changes on a branch.
 *  - Make changes!
 *  - Send pull request from your fork.
 *  - We'll review it, and push your changes to the site!
 *
 * \section Setup
 *  - Learn a bit about Git and Github:
 *      - <a href="http://help.github.com">http://help.github.com</a>
 *      - <a href="http://learn.github.com">http://learn.github.com</a>
 *  - Download the <a href="http://qt-project.org/downloads">Qt SDK</a>.
 *  - Download the source code.
 *  - Open the \c wint-im.pro file.
 *  - Configure the project.
 *  - Hack the source code.
 *  - Compile it and have fun!
 */

/// Creates a new \c QApplication, configures and loads the QML interface,
/// creates a new \c QQuickWindow to draw the QML interface and runs the app.
///
/// \param argc the argument count
/// \param argv the argument data
int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    Bridge bridge;
    Settings settings;

    QDir emotesDir(":/emotes/");
    QStringList emotesList = emotesDir.entryList(QStringList("*.png"));

    QDir facesDir(":/faces/");
    QStringList facesList = facesDir.entryList(QStringList("*.jpg")) +
                            facesDir.entryList(QStringList("*.png"));

    QQmlEngine* engine = new QQmlEngine();
    QQmlComponent* component = new QQmlComponent(engine);
    engine->rootContext()->setContextProperty("bridge", &bridge);
    engine->rootContext()->setContextProperty("settings", &settings);
    engine->rootContext()->setContextProperty("device", &bridge.manager);

    engine->rootContext()->setContextProperty("facesList",
                                              QVariant::fromValue(facesList));
    engine->rootContext()->setContextProperty("emotesList",
                                              QVariant::fromValue(emotesList));

    if (MOBILE_TARGET)
        component->loadUrl(QUrl("qrc:/qml/mobileApp.qml"));
    else
        component->loadUrl(QUrl("qrc:/qml/desktopApp.qml"));

    QQuickWindow* window = qobject_cast<QQuickWindow*>(component->create());
    window->setScreen(app.primaryScreen());

    if (LINUX || WINDOWS)
        window->setIcon(QIcon(":/icons/Logo.svg"));

    MOBILE_TARGET ? window->showMaximized() : window->showNormal();
    return app.exec();
}
