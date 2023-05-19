/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/

#include <QGuiApplication>
#include <QProcessEnvironment>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QScreen>
#include <QSettings>

int
main(int argc, char* argv[]) {
#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS) && !defined(Q_OS_WINRT) &&    \
    !defined(Q_OS_BLACKBERRY)
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
#endif
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qApp->setOrganizationName("Company");
    qApp->setApplicationName("Example");
    qApp->setApplicationVersion("1.0.0");
    QSettings::setDefaultFormat(QSettings::IniFormat);
    QLocale::setDefault(QLocale(QLocale::English, QLocale::UnitedStates));

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:///");
    engine.rootContext()->setContextProperty(
        "HASVIRTUALKEYBOARD",
        QProcessEnvironment::systemEnvironment().value("QT_IM_MODULE") ==
            "qtvirtualkeyboard");
    engine.rootContext()->setContextProperty("buildDate", __DATE__);
    engine.rootContext()->setContextProperty("buildTime", __TIME__);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
