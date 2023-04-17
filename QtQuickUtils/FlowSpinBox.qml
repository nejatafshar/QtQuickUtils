
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

Flow {
    id: root

    property alias name: ilabel.text
    property alias suffix: isuffixLabel.text
    property alias value: ispinBox.value
    property alias spinBox: ispinBox
    property alias label: ilabel
    property alias suffixLabel: isuffixLabel
    property int minFlowThreshold: Math.min(internal.ppi * 4.5,
                                            internal.ppiz * 3.5)
    property int threshold: Math.max(ilabel.implicitWidth + irow.implicitWidth,
                                     minFlowThreshold)
    property bool twoRow: width <= threshold && !alwaysOneRow
    property bool alwaysOneRow: false

    signal focused

    spacing: !twoRow ? internal.ppi * 0.1 : -internal.ppi * 0.1

    QtObject {
        id: internal

        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
    }

    Label {
        id: ilabel

        height: ispinBox.height
        verticalAlignment: Label.AlignVCenter
    }
    Row {
        id: irow

        spacing: 0.04 * internal.ppiz

        SpinBox {
            id: ispinBox

            onFocusChanged: {
                if (focus)
                    root.focused()
            }

            LayoutMirroring.enabled: false
            editable: true
            anchors.verticalCenter: parent.verticalCenter
        }
        Label {
            id: isuffixLabel

            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
