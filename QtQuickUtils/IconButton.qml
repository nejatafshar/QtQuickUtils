
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

Button {
    id: root

    property alias itemIcon: iicon.text
    property alias iconSize: iicon.font.pointSize
    property alias iconLabel: iicon

    width: text ? implicitWidth + iicon.width : implicitWidth
    leftPadding: iicon.width + internal.ppi * 0.2
    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
        property int h2: typeof scl !== "undefined" ? scl.h2 : 14
    }

    Label {
        id: iicon
        font.family: fontAwesome.name
        font.pointSize: internal.h2
        anchors.left: parent.left
        anchors.leftMargin: internal.ppi * 0.1
        anchors.verticalCenter: parent.verticalCenter
    }
}
