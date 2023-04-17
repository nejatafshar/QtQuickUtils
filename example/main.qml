import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuickUtils 1.0

ExtendedApplicationWindow {
    id: win

    onLoginAsked: {
        loginDialog.acceptLogin()
    }

    appName: qsTr("Test Application")
    appVersion: "1.0.0"
    builtOn: buildDate + " " + buildTime
    copyrightYears: "2021-Present"
    companyName: qsTr("Company Name")
    appLogo: "qrc:/icon.png"
    licenseFile: "qrc:/license.txt"
    splashScreen.imageSource: "qrc:/splash.svg"
    title: appName
    font.pointSize: scl.h3
    loginDialog.usernameTextField.text: "test"
    loginDialog.passwordTextField.text: "1234"

    Flickable {
        anchors.fill: parent

        ColorPicker {
            width: scl.button
            height: width
            buttonTooltip: qsTr("Select Color")
            button.font.pointSize: scl.h1
            currentColor: accent1
        }
        BusyIndicator2 {}
        AvatarControl {
            name: "John"
            family: "Smith"
        }
    }
}
