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
#include <QFontDatabase>
#include <QQmlApplicationEngine>

#include "Common/Headers/Bridge.h"
#include "Common/Headers/Settings.h"
#include "Common/Headers/DeviceManager.h"

int main(int argc, char **argv) {  
  //! [Preliminary jobs]
  QNetworkProxyFactory::setUseSystemConfiguration(true);
  //! [Preliminary jobs]

  //! [Setup QApplication]
  QApplication app(argc, argv);
  app.setApplicationName("WinT Messenger");
  app.setApplicationVersion("1.1.3");
  //! [Setup QApplication]

  //! [Create C++/QML communication modules]
  Bridge *bridge = new Bridge();
  Settings *settings = new Settings();
  DeviceManager *manager = new DeviceManager();
  //! [Create C++/QML communication modules]

  //! [Setup QML engine]
  QQmlApplicationEngine *engine = new QQmlApplicationEngine();
  engine->rootContext()->setContextProperty("Settings", settings);
  engine->rootContext()->setContextProperty("Bridge",   bridge);
  engine->rootContext()->setContextProperty("DeviceManager",  manager);
  //! [Setup QML engine]

  //! [Load main.qml]
  QQmlComponent *component = new QQmlComponent(engine);
  component->loadUrl(QUrl("qrc:/QML/main.qml"));
  //! [Load main.qml]

  //! [Create root QObject and window]
  QObject *root = component->create();
  QQuickWindow *window = qobject_cast<QQuickWindow *>(root);
  settings->fullscreen() ? window->showFullScreen() : window->showNormal();
  //! [Create root QObject and window]

  //! [Resize window if first launch]
  if (!DeviceManager::isMobile()) {
      if (settings->firstLaunch()) {
          window->setWidth(720);
          window->setHeight(540);
        }
    }
  //! [Resize window if first launch]

  //! [Load application stylesheet]
  QFile stylesheet(":/css/style.css");
  stylesheet.open(QFile::ReadOnly);
  app.setStyleSheet(QString::fromUtf8(stylesheet.readAll()));
  stylesheet.close();
  //! [Load application stylesheet]

  //! [Execute app]
  return app.exec();
  //! [Execute app]
}
