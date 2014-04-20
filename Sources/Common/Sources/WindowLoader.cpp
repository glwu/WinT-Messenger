#include "../Headers/WindowLoader.h"

void WindowLoader::start() {
    bridge = new Bridge();
    settings = new Settings();
    deviceManager = new DeviceManager();

    engine = new QQmlEngine();
    component = new QQmlComponent(engine);

    engine->rootContext()->setContextProperty("Settings", settings);
    engine->rootContext()->setContextProperty("Bridge",   bridge);
    engine->rootContext()->setContextProperty("DeviceManager",  deviceManager);

    component->loadUrl(QUrl("qrc:/QML/main.qml"));
    window = qobject_cast<QQuickWindow *>(component->create());

    if (settings->fullscreen())
        window->showFullScreen();
    else
        window->showNormal();
}
