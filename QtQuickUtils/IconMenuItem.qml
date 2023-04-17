
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

MenuItem {
    id: root

    property alias itemIcon: iicon.text
    property alias itemIconFont: iicon.font
    property alias shortcut: ishortcut

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
        property int h1: typeof scl !== "undefined" ? scl.h1 : 16
        property int h2: typeof scl !== "undefined" ? scl.h2 : 14
    }

    height: visible ? implicitHeight : 0
    leftPadding: checkable || mirrored ? -internal.ppi * 0.25 : height
    rightPadding: !checkable && mirrored ? height : -internal.ppi * 0.25
    font.pointSize: internal.h2
    indicator: Item {
        id: irow

        width: root.height
        height: root.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Label {
            id: iicon

            font.family: fontAwesome.name
            visible: !root.checkable
            anchors.centerIn: parent
            font.pointSize: internal.h1
        }

        CheckDelegate {
            checked: root.checked
            anchors.centerIn: parent
            height: parent.height
            width: height
            padding: 0
            spacing: 0
            visible: root.checkable && itemIcon === ""
            background: Item {}
            onClicked: {
                root.action.trigger()
            }
        }

        Button {
            id: ibutton

            text: iicon.text
            font.family: iicon.font.family
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            visible: root.checkable && itemIcon !== ""
            checkable: true
            checked: root.checked
            padding: 0
            spacing: 0
            leftInset: 10
            rightInset: 10
            onCheckedChanged: root.checked = checked
            flat: true
            height: parent.height
            width: height

            font.pixelSize: internal.h2
            background: Rectangle {
                opacity: 0.3
                color: ibutton.checked ? "black" : "transparent"
            }
            onClicked: {
                if (root.action)
                    root.action.trigger()
            }
        }
    }
    Shortcut {
        id: ishortcut

        onActivated: root.onClicked()
    }
}
