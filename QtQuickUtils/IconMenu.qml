
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

Menu {
    id: root

    property bool rightToLeftDirection: typeof rightToLeft !== "undefined"
                                        && rightToLeft
    property string itemIcon

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
        property int h3: typeof scl !== "undefined" ? scl.h3 : 12
    }

    delegate: IconMenuItem {
        id: imenuItem

        itemIcon: typeof subMenu !== "undefined" ? subMenu.itemIcon : ""
        arrow: Label {
            text: menu && menu.rightToLeftDirection ? "" : ""
            font.family: fontAwesome.name
            font.pointSize: internal.h3
            anchors.right: parent.right
            anchors.rightMargin: internal.ppi * 0.05
            anchors.verticalCenter: parent.verticalCenter
            LayoutMirroring.enabled: menu && menu.rightToLeftDirection
        }
    }

    overlap: rightToLeftDirection && (typeof rightToLeft === "undefined"
                                      || !rightToLeft) ? -internal.ppi * 0.2 : 0
    width: {
        var result = 0
        var p = 0
        var lp = 0
        var rp = 0
        for (var i = 0; i < count; ++i) {
            var item = itemAt(i)
            result = Math.max(item.contentItem.implicitWidth, result)
            p = Math.max(item.padding, p)
            lp = Math.max(item.leftPadding, lp)
            rp = Math.max(item.rightPadding, rp)
        }
        return result + Math.max(p * 2, lp + rp) + internal.ppi * 0.1
    }
}
