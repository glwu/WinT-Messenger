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
#include "updater.h"
#include "settings.h"
#include "device_manager.h"

//==========================================================================//
//Welcome to the source code! (if there's a better way to say it, tell me)  //
//--------------------------------------------------------------------------//
//You will find a comment on the beggining of the declaration of each class //
//(in the header files) that explains what does that specific class do and  //
//why do we need it.                                                        //
//Through the program, you may find block comments that explain what a      //
//specific set of functions does, but you will rarely find comments inside a//
//function.                                                                 //
//If you want to edit the code, please try to make most of your lines to fit//
//into an 80-character line, if the line is longer, please try (if possible)//
//to split it as nescesary.                                                 //
//Suggestions are always welcome! Send me an email to alex.racotta@gmail.com//
//to communicate with me.                                                   //
//==========================================================================//

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    //=======================================================================//
    //Create the C++/QML communication modules;                              //
    //These are used to call C++ functions from QML and to send data, such as//
    //messages and file names to the QML interface.                          //
    //=======================================================================//

    Bridge bridge;
    Updater updater;
    Settings settings;
    DeviceManager device;

    //=======================================================================//
    //Create the QML interface, load main.qml & make the selected C++ classes//
    //accessible from QML.                                                   //
    //=======================================================================//

    QQmlEngine* engine = new QQmlEngine();
    QQmlComponent* component = new QQmlComponent(engine);
    QObject::connect(engine, SIGNAL(quit()), qApp, SLOT(quit()));

    // Add the QML/C++ modules to the QML engine
    engine->rootContext()->setContextProperty("bridge", &bridge);
    engine->rootContext()->setContextProperty("device", &device);
    engine->rootContext()->setContextProperty("updater", &updater);
    engine->rootContext()->setContextProperty("settings", &settings);

    // Load main.qml and create a window
    component->loadUrl(QUrl("qrc:/qml/main.qml"));
    QQuickWindow* window = qobject_cast<QQuickWindow*>(component->create());
    window->setDefaultAlphaBuffer(true);
    window->setScreen(app.primaryScreen());

    //=====================================================================//
    //Show the QML window in a different state depending on the device type//
    //and the settings.                                                    //
    //=====================================================================//

    if (device.isMobile())
        window->showFullScreen();

    // Decide how to show the window in desktop operating systems
    else {
        if (settings.fullscreen())
            window->showFullScreen();
        else if (settings.maximized())
            window->showMaximized();
        else
            window->showNormal();
    }

    //==========================//
    // Finally, execute the app.//
    //==========================//

    return app.exec();
}
