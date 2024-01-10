#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "debug_interceptor.hpp"
#include "CMakeConfig.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    auto debugInterceptor = Debug_Interceptor::getInstance();

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("ROOT_PATH", ROOT_PATH);

    const QUrl url(u"qrc:/SmartCity/src_gui/Main.qml"_qs);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
