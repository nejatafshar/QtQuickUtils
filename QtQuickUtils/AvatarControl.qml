
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtGraphicalEffects 1.15

Rectangle {
    id: root

    property string name: ""
    property string family: ""
    property string username: ""
    property string source: ""
    property bool clickable: true
    property bool alarm: false
    property int insets: 0
    property alias hovered: itoolButton.hovered
    property alias tooltipText: itooltip.text

    signal clicked

    function hashCode(str) {
        var hash = 0
        for (var i = 0; i < str.length; i++) {
            hash = str.charCodeAt(i) + hash
        }
        return Math.abs(hash % 255) / 255
    }

    color: source === "" ? Qt.hsla(hashCode(name + family + username), 1, 0.25,
                                   1) : "transparent"
    radius: width
    Material.elevation: 7

    Row {

        visible: source === "" && (name !== "" || family !== "")
        anchors.centerIn: parent
        spacing: 0
        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: true
        layoutDirection: {
            var english = /^[A-Za-z0-9]*$/
            if (english.test(name))
                Qt.LeftToRight
            else
                Qt.RightToLeft
        }
        Label {
            text: name.charAt(0).toLocaleUpperCase()
            font.pixelSize: root.height / 2.2
            font.bold: true
            Material.elevation: 7
            Material.foreground: "white"
        }
        Label {
            text: family.charAt(0).toLocaleUpperCase()
            font.pixelSize: root.height / 2.2
            font.bold: true
            Material.elevation: 7
            Material.foreground: "white"
        }
    }

    Label {
        visible: source === "" && name === "" && family === ""
        text: username.charAt(0).toLocaleUpperCase()
        font.pixelSize: root.height / 1.5
        font.bold: true
        anchors.centerIn: parent
        Material.elevation: 7
        Material.foreground: "white"
    }

    Image {
        id: iavatarImage

        anchors.fill: parent
        source: root.source
        fillMode: Image.PreserveAspectFit
        mipmap: true
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: iavatarImage.width
                height: iavatarImage.height
                Rectangle {
                    anchors.fill: parent
                    radius: parent.width
                }
            }
        }
    }

    ToolButton {
        id: itoolButton

        topInset: insets
        rightInset: insets
        leftInset: insets
        bottomInset: insets

        onClicked: {
            root.clicked()
        }
        anchors.fill: parent
        enabled: clickable

        ToolTip {
            id: itooltip

            visible: parent.hovered
            text: qsTr("User Profile")
            delay: 200
            timeout: 3000
            font.bold: true
        }
    }

    Rectangle {
        visible: root.alarm

        width: parent.height / 4
        height: parent.height / 4
        color: "red"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: width / 4.5
        radius: width
        Material.elevation: 20
    }
}
