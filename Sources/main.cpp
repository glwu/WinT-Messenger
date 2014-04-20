//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include <QApplication>
#include <QFontDatabase>
#include <QNetworkProxyFactory>

#include "Common/Headers/WindowLoader.h"

int main(int argc, char **argv) {  
    QNetworkProxyFactory::setUseSystemConfiguration(true);

    QApplication app(argc, argv);
    app.setApplicationName("WinT Messenger");
    app.setApplicationVersion("1.1.3");

    QFontDatabase::addApplicationFont(":/fonts/Regular.ttf");
    app.setFont(QFont("Open Sans"));

    QFile stylesheet(":/css/style.css");
    stylesheet.open(QFile::ReadOnly);
    app.setStyleSheet(QString::fromUtf8(stylesheet.readAll()));
    stylesheet.close();

    WindowLoader loader;
    loader.start();

    return app.exec();
}
