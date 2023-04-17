QT += qml quick quickcontrols2

CONFIG += c++17

CONFIG += qtquickcompiler

TARGET = example

SOURCES += main.cpp

RESOURCES += resources.qrc

include(../QtQuickUtils.pri)

DEFINES += QT_DEPRECATED_WARNINGS


# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
