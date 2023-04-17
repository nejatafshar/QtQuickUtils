
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
import QtQuick.Window 2.15

TabButton {
    id: root

    property string tabText
    property string tabIcon
    property real iconSize: internal.h2
    property real textSize: internal.h3
    property bool bold: false
    property alias iconLabel: iiconLabel
    property alias textLabel: itextLabel
    property alias itemsSpacing: icolumn.spacing

    bottomPadding: 0

    QtObject {
        id: internal

        property int h2: typeof scl !== "undefined" ? scl.h2 : 14
        property int h3: typeof scl !== "undefined" ? scl.h3 : 12
    }

    contentItem: Column {
        id: icolumn

        anchors.centerIn: parent
        spacing: height * 0.1
        width: parent.width

        Label {
            id: iiconLabel

            font.family: fontAwesome.name
            font.pointSize: root.iconSize
            text: root.tabIcon
            color: root.checked ? Material.accent : Material.foreground
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: itextLabel

            text: root.tabText
            font.pointSize: root.textSize
            font.bold: root.bold
            color: root.checked ? Material.accent : Material.foreground
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width + root.padding * 2
            wrapMode: Label.WordWrap
            horizontalAlignment: Label.AlignHCenter
        }
    }
}
