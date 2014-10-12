//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include <time.h>

#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QApplication>
#include <QQmlComponent>
#include <QDesktopServices>

#include "bridge.h"
#include "settings.h"
#include "app_info.h"

int generate_random_number (int max, int min)
{
    srand (time (NULL));
    return rand() % (max - min + 1) + min;
}

int main (int argc, char *argv[])
{
    QApplication m_app (argc, argv);
    m_app.setApplicationName (APP_NAME);
    m_app.setApplicationVersion (APP_VERSION);

    Bridge m_bridge;
    Settings m_settings;

    QDir _emoji_dir (":/smileys/smileys/");
    QStringList m_emoji_list = _emoji_dir.entryList (QStringList ("*.png"));

    QDir _faces_dir (":/faces/faces/");
    QStringList m_faces_list = _faces_dir.entryList (QStringList ("*.jpg")) +
                               _faces_dir.entryList (QStringList ("*.png"));

    QString m_random_face = m_faces_list.at (generate_random_number (m_faces_list.count() - 1, 0));

    QQmlEngine *m_engine = new QQmlEngine();
    m_engine->rootContext()->setContextProperty ("bridge", &m_bridge);
    m_engine->rootContext()->setContextProperty ("settings", &m_settings);
    m_engine->rootContext()->setContextProperty ("device", &m_bridge.manager);
    m_engine->rootContext()->setContextProperty ("facesList", QVariant::fromValue (m_faces_list));
    m_engine->rootContext()->setContextProperty ("emojiList", QVariant::fromValue (m_emoji_list));
    m_engine->rootContext()->setContextProperty ("randomFace", QVariant::fromValue (m_random_face));
    m_engine->rootContext()->setContextProperty ("appName",    APP_NAME);
    m_engine->rootContext()->setContextProperty ("appCompany", COMPANY_NAME);
    m_engine->rootContext()->setContextProperty ("appVersion", APP_VERSION);
    m_engine->rootContext()->setContextProperty ("bitAddress", BITCOIN_ADDRESS);
    m_engine->addImageProvider ("profile-pictures", m_bridge.imageProvider);

    QQmlComponent *m_component = new QQmlComponent (m_engine);
    m_component->loadUrl (QUrl ("qrc:/qml/qml/main.qml"));
    QQuickWindow *m_window = qobject_cast<QQuickWindow *> (m_component->create());

    MOBILE_TARGET ? m_window->showMaximized() : m_window->showNormal();

    return m_app.exec();
}