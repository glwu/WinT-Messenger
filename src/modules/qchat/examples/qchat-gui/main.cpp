//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "window.h"
#include <qapplication.h>

int main(int argc, char *argv[]) {
    // Create the application
    QApplication app(argc, argv);
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("WinT 3794");
    app.setApplicationName("qChat Example");

    // Show the window
    Window window;
    window.show();

    // Return the value of the application
    return app.exec();
}
