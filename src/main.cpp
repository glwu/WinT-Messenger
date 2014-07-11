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
 * You can see how the whole app works here, or even write code to make it better!
 *
 * \section Contributing
 *
 *  - Join <a href="https://groups.google.com/forum/#!forum/wint-messenger-developers">
 the mailing lists</a> to stay up to date with the development!.
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

    // Create the bridge module, which is used to fire up the Chat engine
    // and setup the communications between the QML interface and the Chat engine
    Bridge bridge;

    // Create the settings wrapper for QML
    Settings settings;

    // Create the device manager, which allows us to resize the QML controls to fit the
    // display in mobile devices and allows us to get very basic device information
    DeviceManager device;

    // Load all the PNG images found inside the qrc:/emotes folder into a QStringList
    QDir emotesDir(":/emotes/");
    QStringList emotesList = emotesDir.entryList(QStringList("*.png"));

    // Load all the PNG and JPG images found inside the qrc:/emotes folder into a QStringList
    QDir facesDir(":/faces/");
    QStringList facesList = facesDir.entryList(QStringList("*.jpg")) + facesDir.entryList(QStringList("*.png")) ;

    // Create the QML engine and the QML Component (which will be loaded inside the QQuickWindow
    QQmlEngine* engine = new QQmlEngine();
    QQmlComponent* component = new QQmlComponent(engine);

    // Allow the QML interface to gain access to the selected C++ objects
    engine->rootContext()->setContextProperty("bridge", &bridge);
    engine->rootContext()->setContextProperty("device", &device);
    engine->rootContext()->setContextProperty("settings", &settings);
    engine->rootContext()->setContextProperty("facesList", QVariant::fromValue(facesList));
    engine->rootContext()->setContextProperty("emotesList", QVariant::fromValue(emotesList));

    // Load a different main QML file depending on the Operating System
    if (device.isMobile())
        component->loadUrl(QUrl("qrc:/qml/mobileApp.qml"));
    else
        component->loadUrl(QUrl("qrc:/qml/desktopApp.qml"));

    // Create the window and load it in the primary screen of the device
    QQuickWindow* window = qobject_cast<QQuickWindow*>(component->create());
    window->setScreen(app.primaryScreen());

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    // Allow the window to display the system's statusbar and controls under mobile systems
    window->showMaximized();
#else
    // Show the window noramlly under desktop systems
    window->showNormal();
#endif

    // Execute the application
    return app.exec();
}
