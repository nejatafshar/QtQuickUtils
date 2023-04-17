
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
import QtQuick.Layouts 1.15

ComboBox {
    id: root

    onActivated: scl.zoom = currentValue / 100

    Component.onCompleted: {
        currentIndex = find(scl.zoom * 100)
    }

    Connections {
        function onZoomChanged() {
            if (currentValue !== scl.zoom * 100)
                currentIndex = find(scl.zoom * 100)
        }

        target: scl
    }

    model: [75, 100, 125, 150, 175, 200]
    currentIndex: 1
    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true
    font.pointSize: scl.h3
    delegate: ItemDelegate {
        width: root.width
        height: root.height * 1.2
        font.pointSize: scl.h4
        contentItem: Label {
            text: modelData + "%"
            color: root.currentIndex === index ? parent.Material.accent : parent.Material.foreground
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }
        highlighted: root.highlightedIndex === index
    }
    popup.y: -popup.height
    indicator: Label {
        id: iinidicatorLabel

        parent: root
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: scl.spacing * 3
        font.family: fontAwesome.name
        text: ""
        font.pointSize: scl.h3
    }
    contentItem: Label {
        verticalAlignment: Text.AlignVCenter
        leftPadding: iinidicatorLabel.width + scl.spacing * 4
        font.pointSize: scl.h4
        text: currentValue + "%"
    }
    width: scl.dpiz * 0.7

    ToolTip {
        visible: parent.hovered
        text: qsTr("Zoom")
        delay: 200
        timeout: 3000
        font.bold: true
    }
}
