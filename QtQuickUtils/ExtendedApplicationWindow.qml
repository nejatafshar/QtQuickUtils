
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Controls.Material 2.15
import Qt.labs.settings 1.1

ApplicationWindow {
    id: win

    property color dark_accent1: "#00699d"
    property color dark_accent2: "#00B0FF"
    property color dark_background1: "#080808"
    property color dark_background2: "#323232"
    property color dark_foreground1: "#FFFFFF"
    property color dark_foreground2: "#FFFFFF"
    property color dark_positive: "#4caf50"
    property color dark_negative: "#f44336"

    property color light_accent1: "#00B0FF"
    property color light_accent2: "#00699d"
    property color light_background1: "#f5f5f5"
    property color light_background2: "#eeeeee"
    property color light_foreground1: "#dd000000"
    property color light_foreground2: "#ffffff"
    property color light_positive: "#388E3C"
    property color light_negative: "#D32F2F"

    property real fontScale: -1

    property alias appName: iaboutWindow.appName
    property alias appVersion: iaboutWindow.appVersion
    property alias builtOn: iaboutWindow.builtOn
    property alias copyrightYears: iaboutWindow.copyrightYears
    property alias companyName: iaboutWindow.companyName
    property alias appLogo: iaboutWindow.appLogo
    property alias companyLogo: iaboutWindow.companyLogo
    property alias licenseFile: iaboutWindow.licenseFile
    property alias aboutWindow: iaboutWindow
    property alias splashScreen: isplashScreen
    property alias loginDialog: iloginDialog
    property alias messagePopup: imessagePopup
    property alias scl: iscale
    property int previousVisibility: ApplicationWindow.Maximized
    property string deviceType: Qt.platform.os === "android"
                                || Qt.platform.os === "ios"
                                || Qt.platform.os === "winrt" ? "mobile" : "desktop"
    property bool darkTheme: Material.theme === Material.Dark
    property color background1: darkTheme ? dark_background1 : light_background1
    property color background2: darkTheme ? dark_background2 : light_background2
    property color foreground1: darkTheme ? dark_foreground1 : light_foreground1
    property color foreground2: darkTheme ? dark_foreground2 : light_foreground2
    property color accent1: darkTheme ? dark_accent1 : light_accent1
    property color accent2: darkTheme ? dark_accent2 : light_accent2
    property color positive: darkTheme ? dark_positive : light_positive
    property color negative: darkTheme ? dark_negative : light_negative

    property alias appFont: iappFont
    property alias fontAwesome: ifontAwesome
    property bool showSplashScreen: deviceType === "desktop"
    property bool closed: false
    property bool rightToLeft: false
    property string defaultFont: idummyControl.font.family
    property var idummyControl: Control {}
    property bool loginOnStart: true
    property bool loggedin: iloginDialog.loggedin
    property bool saveLastWindowState: true
    property bool isLoginModeOnDesktop: deviceType === "desktop"
                                        && !isplashScreen.visible
                                        && (iloginDialog.visible
                                            || iloginDialog.loggedin)
                                        && !loggedin
    property alias virtualKeyboard: ivirtualKeybaordLoader.item
    property bool enableVirtualKeyboard: false

    signal loginAsked(string username, string password, string captcha)
    signal logoutAsked

    onVisibilityChanged: {
        if (loggedin && visibility === ApplicationWindow.Maximized
                || visibility === ApplicationWindow.FullScreen)
            isettings.visibility = win.visibility
    }

    function showMessage(message, title, par) {
        imessagePopup.text = message
        if (title !== undefined)
            imessagePopup.dialogTitle = title
        imessagePopup.parent = (par !== undefined ? par : Overlay.overlay)
        imessagePopup.open()
        imessagePopup.forceActiveFocus()
    }

    function setGeometryForLoginModeOnDesktop() {
        if (isLoginModeOnDesktop && !iloginDialog.movedByUser) {
            x = Qt.binding(function () {
                return screen.virtualX + (Screen.width - width) / 2
            })
            y = Qt.binding(function () {
                return screen.virtualY + (Screen.height - height) / 2
            })
            width = Qt.binding(function () {
                return iloginDialog.width
            })
            height = Qt.binding(function () {
                return iloginDialog.height
            })
        }
    }

    onIsLoginModeOnDesktopChanged: {
        if (isLoginModeOnDesktop) {
            minimumWidth = 0
            minimumHeight = 0
            setGeometryForLoginModeOnDesktop()
            visibility = ApplicationWindow.Windowed
            color = "transparent"
            modality = Qt.ApplicationModal
            flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint
        } else {
            minimumWidth = 480
            minimumHeight = 480
            width = minimumWidth
            height = minimumHeight
            x = screen.virtualX + (Screen.width - width) / 2
            y = screen.virtualY + (Screen.height - height) / 2
            color = background1
            modality = Qt.NonModal
            flags = Qt.Window
            visibility = isettings.visibility
        }
    }
    onWidthChanged: setGeometryForLoginModeOnDesktop()
    onHeightChanged: setGeometryForLoginModeOnDesktop()
    onXChanged: setGeometryForLoginModeOnDesktop()
    onYChanged: setGeometryForLoginModeOnDesktop()

    visibility: {
        if (isplashScreen.visible)
            ApplicationWindow.Hidden
        else if (isLoginModeOnDesktop)
            ApplicationWindow.Windowed
        else if (isettings.visibility !== ApplicationWindow.Hidden)
            isettings.visibility
        else
            ApplicationWindow.Maximized
    }
    screen: Qt.application.screens[0]
    minimumWidth: 480
    minimumHeight: 480
    font.family: appFont.name
    LayoutMirroring.enabled: rightToLeft
    LayoutMirroring.childrenInherit: true
    // theme
    Material.theme: Material.Dark
    Material.background: background1
    Material.accent: accent1
    Material.primary: background1

    Settings {
        id: isettings

        property alias curTheme: win.darkTheme
        property alias scale: iscale.zoom
        property alias enableVirtualKeyboard: win.enableVirtualKeyboard
        property int visibility: ApplicationWindow.Maximized

        category: "AppSettings"
    }
    FontLoader {
        id: iappFont

        source: "qrc:/QtQuickUtils/fonts/RobotoYekanRB.ttc"
    }
    FontLoader {
        id: ifontAwesome

        source: "qrc:/QtQuickUtils/fonts/Font Awesome 6 Free-Solid-900.otf"
    }

    Connections {
        function finishSplash() {
            if (loginOnStart && !loggedin)
                iloginDialog.openLogin()
            else
                iloginDialog.loggedin = true
            isplashScreen.close()
        }
        Component.onCompleted: {
            if (!showSplashScreen)
                finishSplash()
        }
        function onTimeout() {
            finishSplash()
        }

        target: isplashScreen
        enabled: showSplashScreen
    }

    AboutWindow {
        id: iaboutWindow
    }

    property var ss: SplashScreen {
        id: isplashScreen
        visible: showSplashScreen
    }

    MessagePopup {
        id: imessagePopup
    }

    LoginDialog {
        id: iloginDialog
    }

    Loader {
        id: ivirtualKeybaordLoader

        anchors.left: parent.left
        anchors.right: parent.right
        source: typeof HASVIRTUALKEYBOARD !== "undefined" && HASVIRTUALKEYBOARD
                && deviceType === "desktop" ? "VirtualKeyboard.qml" : ""
        asynchronous: true
    }

    QtObject {
        id: iscale

        property real zoom: deviceType === "desktop" ? 1 : 1.5
        property real fontScale: win.fontScale > 0 ? win.fontScale : 1

        property int ppi: typeof dpi !== "undefined" ? dpi : Screen.pixelDensity * 25.4
        property int dpiz: ppi * zoom

        property int spacing: 0.04 * ppi * zoom
        property int fspacing: 0.04 * ppi
        property int flspacing: 0.02 * ppi
        property int bigSpacing: spacing * 2
        property int margin: 0.1 * ppi * zoom
        property int drawer: ppi * 2.8 * zoom
        property int drawerHeader: ppi * 0.6 * zoom
        property int scrollBar: ppi * 0.1 * zoom
        property int section: ppi * 0.5 * zoom
        property int delegate: ppi * 0.2 * zoom
        property int component: 40 * zoom
        property int toolBar: 40 * zoom
        property int menuBar: 43 * zoom
        property int statusBar: ppi * 0.3 * zoom
        property int menuItem: 40 * zoom
        property int button: ppi * 0.25 + (dpiz * 0.2)
        property int toolButton: ppi * 0.6 * zoom

        property int h0: 20 * zoom * fontScale
        property int h1: 16 * zoom * fontScale
        property int h2: 14 * zoom * fontScale
        property int h3: 12 * zoom * fontScale
        property int h4: 10 * zoom * fontScale
        property int h5: 8 * zoom * fontScale

        property int s30: 30 * zoom
        property int s35: 35 * zoom
        property int s40: 40 * zoom
        property int s45: 45 * zoom
        property int s50: 50 * zoom
        property int s60: 60 * zoom
    }
}
