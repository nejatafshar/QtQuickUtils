
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Extras 1.4

ExtendedDialog {
    id: root

    property string companyBareLogo
    property var materialTheme: win.Material.theme
    property color materialBackground: background1
    property alias usernameTextField: iusername
    property alias passwordTextField: ipassword
    property alias rememberMe: irememberCheckBox.checked
    property alias virtualKeyboardButton: ivirtualKeyboardButton
    property alias loginButton: iloginButton
    property alias signupButton: isignupButton
    property alias settingsButton: isettingsButton
    property alias rememberCheckBox: irememberCheckBox
    property alias messagePopup: imessagePopup
    property alias scaleSelection: iscaleSelection
    property alias appLogoImage: iappLogoImage
    property alias captchaImageItem: icaptchaImage
    property bool loggedin: false
    property bool movedByUser: false
    property string captchaImage
    property bool showCaptchaItems: captchaImage !== ""
    property alias captchaTextField: icaptcha
    property alias otherItem: iotherItem.data
    property alias flow: iflow

    signal refreshCaptcha

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
        property int spacing: 0.04 * ppiz
        property int bigSpacing: spacing * 2
        property int button: ppi * 0.25 + (ppiz * 0.2)
        property int h2: typeof scl !== "undefined" ? scl.h2 : 14
        property int h3: typeof scl !== "undefined" ? scl.h3 : 12
        property int h5: typeof scl !== "undefined" ? scl.h5 : 8
        property real zoom: typeof scl !== "undefined" ? scl.zoom : 1
    }

    onLoggedinChanged: {
        if (loggedin)
            close()
        else
            openLogin()
    }

    onOpened: {
        if (deviceType === "desktop")
            iusername.forceActiveFocus()
    }

    onRejected: {
        if (closePolicy !== Dialog.NoAutoClose)
            Qt.quit()
    }
    onVisibleChanged: movedByUser = false

    function acceptLogin() {
        iloginButton.activate = true
        ibusyIndicator.visible = false
        root.loggedin = true
        ipassword.text = ""
        icaptcha.text = ""
    }
    function showMessage(message, title) {
        iloginButton.activate = true
        ibusyIndicator.visible = false

        imessagePopup.text = message
        if (title !== undefined)
            imessagePopup.dialogTitle = title
        if (!visible)
            imessagePopup.parent = win.Overlay.overlay
        imessagePopup.open()
        imessagePopup.forceActiveFocus()
    }
    function openLogin() {
        if (!imessagePopup.visible)
            root.open()
    }

    function login() {
        if (iusername.text.length === 0)
            iusername.forceActiveFocus()
        else if (ipassword.text.length === 0)
            ipassword.forceActiveFocus()
        else if (showCaptchaItems && icaptcha.text.length === 0)
            icaptcha.forceActiveFocus()
        else {
            iloginButton.activate = false
            ibusyIndicator.visible = true
            loginAsked(iusername.text, ipassword.text, icaptcha.text)
        }
    }

    signal settingsButtonClicked
    signal signupButtonClicked
    signal messagePopupClosed

    standardButtons: Dialog.NoButton
    closeButtonPosition: Qt.TopLeftCorner
    implicitWidth: internal.ppiz * 5
    implicitHeight: internal.ppiz * 6
    width: deviceType === "desktop" ? Math.min(
                                          implicitWidth,
                                          Screen.desktopAvailableWidth) : parent.width
    height: deviceType === "desktop" ? Math.min(
                                           Math.max(
                                               icolumn.height + internal.ppi
                                               * 1.3 + iappLogoImage.height,
                                               implicitHeight),
                                           Screen.desktopAvailableHeight
                                           - internal.ppi * 0.5) : parent.height
    dialogTitle: qsTr("Login")
    dialogIcon: ""
    movableByMouse: false
    dim: false
    font.pointSize: internal.h3
    headerLayoutMirroring: false
    headerExtraItem: MouseArea {
        property point clickPos: Qt.point(1, 1)

        onPressed: clickPos = Qt.point(mouse.x, mouse.y)
        onPositionChanged: {
            movedByUser = true
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            win.x += delta.x
            win.y += delta.y
        }

        width: root.width
        height: internal.ppiz * 0.5
        preventStealing: true
        enabled: deviceType === "desktop"
    }

    MouseArea {
        property point clickPos: Qt.point(1, 1)

        onPressed: clickPos = Qt.point(mouse.x, mouse.y)
        onPositionChanged: {
            movedByUser = true
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            win.x += delta.x
            win.y += delta.y
        }

        anchors.fill: parent
        preventStealing: true
        enabled: deviceType === "desktop"
    }

    Item {
        id: iotherItem
        anchors.fill: parent
    }
    Flow {
        id: iflow

        property bool twoColumns: (iappLogoImage.height + icolumn.height + spacing) > parent.height

        spacing: internal.bigSpacing
        anchors.centerIn: parent
        height: twoColumns ? Math.max(iappLogoImage.height,
                                      icolumn.height) : parent.height
        flow: Flow.TopToBottom
        LayoutMirroring.enabled: false

        Image {
            id: iappLogoImage

            source: appLogo
            fillMode: Image.PreserveAspectFit
            mipmap: true
            width: parent.twoColumns ? height : icolumn.width
            height: internal.ppiz * 1.5
        }

        Column {
            id: icolumn

            spacing: 0.02 * internal.ppi
            width: parent.twoColumns ? Math.min(
                                           internal.ppiz * 3,
                                           iflow.parent.width - internal.ppiz
                                           - parent.spacing) : Math.min(
                                           internal.ppiz * 3.3,
                                           iflow.parent.width)

            ToolButton {
                id: isignupButton

                onClicked: signupButtonClicked()

                text: ""
                font.family: fontAwesome.name
                font.pointSize: internal.h3

                ToolTip {
                    visible: parent.hovered
                    text: qsTr("Sign up")
                    delay: 200
                    timeout: 3000
                    font.family: appFont.name
                    font.bold: true
                }
            }
            TextField {
                id: iusername

                Keys.onReturnPressed: root.login()
                Keys.onEnterPressed: root.login()

                placeholderText: qsTr("Username")
                width: parent.width
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            }
            PasswordTextField {
                id: ipassword

                Keys.onReturnPressed: root.login()
                Keys.onEnterPressed: root.login()

                placeholderText: qsTr("Password")
                width: parent.width
            }
            Row {
                spacing: internal.spacing
                visible: showCaptchaItems

                TextField {
                    id: icaptcha

                    Keys.onReturnPressed: root.login()
                    Keys.onEnterPressed: root.login()

                    placeholderText: qsTr("Captcha Value")
                    width: parent.parent.width - icaptchaImage.width - internal.spacing
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                    anchors.verticalCenter: parent.verticalCenter
                }
                Image {
                    id: icaptchaImage

                    source: captchaImage
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    width: sourceSize.width * internal.zoom
                    height: sourceSize.height * internal.zoom
                    anchors.verticalCenter: parent.verticalCenter

                    TapHandler {
                        onTapped: refreshCaptcha()
                    }
                    HoverHandler {
                        id: ihoverHandler
                    }
                    ToolTip {
                        visible: ihoverHandler.hovered
                        text: qsTr("Click for new captcha")
                        delay: 200
                        timeout: 3000
                        font.family: appFont.name
                        font.bold: true
                    }
                }
            }

            Item {
                width: parent.width
                height: childrenRect.height
                LayoutMirroring.enabled: typeof rightToLeft !== "undefined"
                                         && rightToLeft

                CheckBox {
                    id: irememberCheckBox

                    Keys.onReturnPressed: root.login()

                    text: qsTr("Remember Me")
                    anchors.left: parent.left
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: internal.spacing
                LayoutMirroring.enabled: false

                ToolButton {
                    id: isettingsButton

                    onClicked: settingsButtonClicked()

                    text: ""
                    font.family: fontAwesome.name
                    font.pointSize: internal.h2
                    height: iloginButton.height
                    width: height
                    ToolTip {
                        visible: parent.hovered
                        text: qsTr("Settings")
                        delay: 200
                        timeout: 3000
                        font.family: appFont.name
                        font.bold: true
                    }
                }
                Button {
                    id: iloginButton

                    property bool activate: true

                    Keys.onReturnPressed: {
                        onClicked()
                    }
                    Keys.onEnterPressed: {
                        onClicked()
                    }

                    onClicked: root.login()

                    height: internal.button
                    width: internal.ppi * 2
                    text: qsTr("Login")
                    enabled: iusername.text.length > 0
                             && ipassword.text.length > 0
                             && (!icaptcha.visible || icaptcha.text.length > 0)
                             && activate
                    Material.background: Material.accent
                    Material.foreground: foreground2
                    font.pointSize: internal.h3
                    font.bold: true
                }
                BusyIndicator {
                    id: ibusyIndicator

                    running: false
                    height: iloginButton.height
                    width: running ? height : 0
                }
            }
        }
    }

    footer: Item {
        width: parent.width
        height: ivirtualKeyboardButton.height
        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: true

        Row {
            spacing: internal.spacing
            anchors.right: parent.right
            anchors.rightMargin: internal.bigSpacing * 2
            anchors.verticalCenter: parent.verticalCenter

            Label {
                text: companyName
                font.pointSize: internal.h5
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Label.AlignRight
            }
            Image {
                id: icompanyLogoImage

                source: companyLogo
                fillMode: Image.PreserveAspectFit
                mipmap: true
                height: Math.min(internal.ppiz * 0.3, parent.parent.height)
                width: height
            }
        }

        Row {
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            ScaleSelection {
                id: iscaleSelection

                height: ivirtualKeyboardButton.height
            }
            ToolButton {
                id: ivirtualKeyboardButton

                onToggled: {
                    enableVirtualKeyboard = checked
                }

                text: ""
                font.family: fontAwesome.name
                font.pointSize: internal.h3
                checkable: true
                checked: enableVirtualKeyboard
                visible: deviceType === "desktop"

                ToolTip {
                    visible: parent.hovered
                    text: qsTr("Virtual Keyboard")
                    delay: 200
                    timeout: 3000
                    font.family: appFont.name
                    font.bold: true
                }
            }
        }
    }

    MessagePopup {
        id: imessagePopup

        onClosed: {
            if (deviceType === "desktop") {
                if (icaptcha.visible && icaptcha.text === "")
                    icaptcha.forceActiveFocus()
                else
                    ipassword.forceActiveFocus()
                icaptcha.text = ""
            }
            messagePopupClosed()
        }

        dim: root.visible
        z: 2
    }
}
