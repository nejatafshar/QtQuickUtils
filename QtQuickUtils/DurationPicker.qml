
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

Pane {
    id: root

    property int value: 0

    function updateTumblers() {
        ihourTumbler.currentIndex = Qt.binding(function () {
            return value / 3600
        })
        iminuteTumbler.currentIndex = Qt.binding(function () {
            return (value % 3600) / 60
        })
        isecondTumbler.currentIndex = Qt.binding(function () {
            return value % 60
        })
    }

    Component.onCompleted: updateTumblers()

    clip: true
    height: internal.ppiz * 1.2
    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    QtObject {
        id: internal

        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
        property bool moving: ihourTumbler.moving || iminuteTumbler.moving
                              || isecondTumbler.moving

        onMovingChanged: {
            if (!moving)
                value = ihourTumbler.currentIndex * 3600 + iminuteTumbler.currentIndex
                        * 60 + isecondTumbler.currentIndex
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height

        Tumbler {
            id: ihourTumbler

            contentItem: ListView {
                model: ihourTumbler.model
                delegate: ihourTumbler.delegate

                snapMode: ListView.SnapToItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: height / 2 - (height / ihourTumbler.visibleItemCount / 2)
                preferredHighlightEnd: height / 2 + (height / ihourTumbler.visibleItemCount / 2)
                clip: true
                currentIndex: value / 3600
            }

            height: parent.height
            model: 25
            visibleItemCount: 3
            delegate: idelegateComponent
        }
        Label {
            text: "h"
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: -ihourTumbler.width / 6
        }
        Tumbler {
            id: iminuteTumbler

            contentItem: ListView {
                model: iminuteTumbler.model
                delegate: iminuteTumbler.delegate

                snapMode: ListView.SnapToItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: height / 2 - (height / iminuteTumbler.visibleItemCount / 2)
                preferredHighlightEnd: height / 2 + (height / iminuteTumbler.visibleItemCount / 2)
                clip: true
                currentIndex: (value % 3600) / 60
            }

            height: parent.height
            model: 60
            visibleItemCount: 3
            delegate: idelegateComponent
        }
        Label {
            text: "m"
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: -iminuteTumbler.width / 6
        }
        Tumbler {
            id: isecondTumbler

            contentItem: ListView {
                model: isecondTumbler.model
                delegate: isecondTumbler.delegate

                snapMode: ListView.SnapToItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: height / 2 - (height / isecondTumbler.visibleItemCount / 2)
                preferredHighlightEnd: height / 2 + (height / isecondTumbler.visibleItemCount / 2)
                clip: true
                currentIndex: value % 60
            }

            height: parent.height
            model: 60
            visibleItemCount: 3
            delegate: idelegateComponent
        }
        Label {
            text: "s"
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: -isecondTumbler.width / 6
        }
    }

    FontMetrics {
        id: ifontMetrics
    }

    Component {
        id: idelegateComponent

        Label {
            text: modelData.toString().length < 2 ? "0" + modelData : modelData
            opacity: 1.0 - Math.abs(
                         Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: Math.max(ifontMetrics.font.pointSize
                                     * (2.0 - Math.abs(2 * Tumbler.displacement)
                                        / Tumbler.tumbler.visibleItemCount), 1)
        }
    }
}
