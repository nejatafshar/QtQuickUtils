
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Window 2.15

ExtendedDialog {
    id: root

    property alias username: iusernameTextField.text
    property alias password: ipasswordTextField.text

    onOpened: {
        iusernameTextField.forceActiveFocus()
    }

    implicitWidth: internal.ppiz * 4
    implicitHeight: internal.ppiz * 3
    contentHeight: iflickable.contentHeight
    dialogIcon: ""
    font.pointSize: internal.h3

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
        property int button: ppi * 0.25 + (ppiz * 0.2)
        property int h3: typeof scl !== "undefined" ? scl.h3 : 12
    }

    contentData: Flickable {
        id: iflickable

        clip: true
        anchors.fill: parent
        interactive: contentHeight > height
        flickableDirection: Flickable.VerticalFlick
        contentWidth: parent.width
        contentHeight: igrid.height
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOn
            visible: iflickable.interactive
        }

        GridLayout {
            id: igrid
            anchors.centerIn: parent
            width: parent.width
            columns: 2
            columnSpacing: internal.ppi * 0.2
            rowSpacing: internal.ppi * 0.1

            Label {
                text: qsTr("Username")
            }
            TextField {
                id: iusernameTextField

                Keys.onReturnPressed: ipasswordTextField.forceActiveFocus()
                Keys.onEnterPressed: ipasswordTextField.forceActiveFocus()

                Layout.fillWidth: true
            }
            Label {
                text: qsTr("Password")
            }
            PasswordTextField {
                id: ipasswordTextField

                Keys.onReturnPressed: accept()
                Keys.onEnterPressed: accept()

                Layout.fillWidth: true
            }
        }
    }
    footer: Item {
        height: iokButton.height

        Row {
            spacing: 0.04 * internal.ppi
            anchors.right: parent.right
            anchors.rightMargin: 0.04 * internal.ppi

            Button {
                onClicked: reject()

                text: qsTr("Cancel")
                Material.background: "transparent"
                Material.foreground: Material.accent
                background.visible: enabled
                font.pointSize: internal.h3
                font.bold: true
                height: internal.button
                width: implicitWidth
            }
            Button {
                id: iokButton

                Keys.onReturnPressed: {
                    onClicked()
                }
                Keys.onEnterPressed: {
                    onClicked()
                }

                onClicked: accept()

                text: qsTr("Ok")
                Material.background: Material.accent
                Material.foreground: foreground2
                font.pointSize: internal.h3
                font.bold: true
                height: internal.button
                width: implicitWidth + internal.ppi * 0.2
            }
        }
    }
}
