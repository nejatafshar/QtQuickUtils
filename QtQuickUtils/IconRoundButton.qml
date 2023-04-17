
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

RoundButton {
    id: root

    property alias itemIcon: iicon.text
    property alias iconSize: iicon.font.pointSize
    property alias iconFont: iicon.font
    property alias iconLabel: iicon

    width: text ? implicitWidth + iicon.width : implicitWidth
    leftPadding: mirrored ? padding : iicon.width + padding
    rightPadding: mirrored ? iicon.width + padding : padding

    QtObject {
        id: internal

        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
    }

    Label {
        id: iicon

        font.family: fontAwesome.name
        font.pointSize: root.font.pointSize
        anchors.left: parent.left
        anchors.leftMargin: internal.ppiz * 0.15
        anchors.verticalCenter: parent.verticalCenter
        font.bold: false
    }
}
