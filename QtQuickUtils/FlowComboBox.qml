
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
    property alias model: icomboBox.model
    property alias currentIndex: icomboBox.currentIndex
    property alias currentText: icomboBox.currentText
    property alias comboBox: icomboBox
    property alias label: ilabel
    property var find: icomboBox.find
    property int threshold: ilabel.implicitWidth + icomboBox.implicitWidth

    signal focused

    spacing: width > threshold ? internal.ppi * 0.1 : -internal.ppi * 0.1

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
    }

    Label {
        id: ilabel

        height: icomboBox.height
        verticalAlignment: Label.AlignVCenter
    }
    ComboBox {
        id: icomboBox

        onModelChanged: {
            if (!model)
                return
            var w = Number.MIN_VALUE
            textMetrics.font = font
            for (var i = 0; i < model.length; i++) {
                textMetrics.text = model[i]
                w = Math.max(textMetrics.width, w)
            }
            implicitWidth = w + 2 * rightPadding + 2 * leftPadding + internal.ppi * 0.8
        }
        onFocusChanged: {
            if (focus)
                root.focused()
        }

        width: parent.width > threshold ? parent.width - ilabel.width
                                          - parent.spacing : parent.width
    }
    TextMetrics {
        id: textMetrics
    }
}
