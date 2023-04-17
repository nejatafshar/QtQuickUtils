
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Window {
    id: root

    property alias timeoutInterval: itimer.interval
    property alias imageSource: isplashImage.source
    property color accentColor: "#14542a"
    property bool timedOut: false
    property bool rescaleImage: true
    property int loadPercentage: 100
    property alias progressBar: iprogressBar
    property int maxWidth: 0
    property int maxHeight: 0

    onTimeout: timedOut = true

    signal timeout

    color: "transparent"
    title: "Splash Window"
    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen | Qt.WindowStaysOnTopHint
    x: deviceType === "desktop" ? (Screen.width - width) / 2 : 0
    y: deviceType === "desktop" ? (Screen.height - height) / 2 : 0
    width: deviceType === "desktop" ? height * 2.5 : Screen.width
    height: deviceType === "desktop" ? Screen.height / 2 : Screen.height
    Component.onCompleted: itimer.start()

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
    }

    Image {
        id: isplashImage

        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(width, height)
        mipmap: true
    }
    Timer {
        id: itimer

        onTriggered: {
            root.timeout()
            root.visible = false
        }

        interval: 3000
        running: true
        repeat: false
    }
    MouseArea {
        onClicked: {
            root.timeout()
            itimer.stop()
            root.visible = false
        }

        anchors.fill: parent
    }
    ProgressBar {
        id: iprogressBar

        anchors {
            bottom: parent.bottom
            bottomMargin: internal.ppi * 0.3
            left: parent.left
            leftMargin: isplashImage.width * 0.07
            right: parent.right
            rightMargin: isplashImage.width * 0.07
        }
        Material.accent: accentColor
        value: loadPercentage
    }
}
