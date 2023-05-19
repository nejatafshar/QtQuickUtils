
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

import QtQuickUtils 1.0

ExtendedApplicationWindow {
    id: win

    onLoginAsked: {
        loginDialog.acceptLogin()
        imessagePanel.showMessage("Welcome to QtQuickUtils example app", "")
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

    MessagePanel {
        id: imessagePanel

        edge: Qt.TopEdge
        implicitWidth: Math.min(
                           Math.max(
                               (Screen.width * 0.33) * (0.4 + scl.zoom * 0.6),
                               scl.dpiz * 5), Screen.width)
        implicitHeight: (win.height / 4) * (0.4 + scl.zoom * 0.6)
    }

    ScrollBar {
        id: iscrollBar
        anchors.left: iflickable.right
        anchors.top: iflickable.top
        anchors.bottom: iflickable.bottom
        policy: ScrollBar.AlwaysOn
        visible: iflickable.interactive
    }
    Flickable {
        id: iflickable

        clip: true
        anchors.fill: parent
        interactive: contentHeight > height
        flickableDirection: Flickable.VerticalFlick
        contentWidth: parent.width
        contentHeight: icolumn.height
        ScrollBar.vertical: iscrollBar

        Column {
            id: icolumn
            width: Math.min(parent.width, scl.dpiz * 5)
            spacing: scl.bigSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            ScaleSelection {
                anchors.horizontalCenter: parent.horizontalCenter
            }
            ColorPicker {
                width: scl.button
                height: width
                buttonTooltip: qsTr("Select Color")
                button.font.pointSize: scl.h1
                currentColor: accent1
                anchors.horizontalCenter: parent.horizontalCenter
            }
            BusyIndicator2 {
                width: scl.button
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
            }
            AvatarControl {
                name: "John"
                family: "Smith"
                width: scl.button
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
            }
            DoubleSpinBox {
                anchors.horizontalCenter: parent.horizontalCenter
                realStepSize: 0.1
            }
            DurationPicker {
                anchors.horizontalCenter: parent.horizontalCenter
            }
            FlowComboBox {
                name: "Flow ComboBox"
                model: ["this is the first item in combo box", "this is the second item in combo box"]
                width: parent.width
            }
            FlowSpinBox {
                name: "Flow SpinBox"
                width: parent.width
            }
            FlowTextField {
                name: "Flow TextField"
                width: parent.width
            }
            IconButton {
                onClicked: {
                    imessagePanel.open()
                }

                itemIcon: ""
                text: "Open Message Panel"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            IconRoundButton {
                onClicked: {
                    var p = mapFromGlobal(mapToGlobal(x, y))
                    iiconMenu.x = icolumn.x + p.x
                    iiconMenu.y = p.y + height
                    iiconMenu.open()
                }

                itemIcon: ""
                text: "Open Icon Menu"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    IconMenu {
        id: iiconMenu

        font.pointSize: scl.h3

        IconMenu {
            title: "options"
            itemIcon: ""

            IconMenuItem {
                text: "item1"
                itemIcon: ""
            }
            IconMenuItem {
                text: "item2"
                itemIcon: ""
            }
        }
        IconMenuItem {
            text: "Settings"
            itemIcon: ""
        }
        IconMenuItem {
            text: "Info"
            itemIcon: ""
        }
    }
}
