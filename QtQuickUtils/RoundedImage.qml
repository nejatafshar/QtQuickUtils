
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

Image {
    id: root

    property real radius: internal.ppi * 0.05
    property bool showBackgroundWhenEmpty: true
    property color backgroundColor: background1
    property var cursorShape: Qt.PointingHandCursor
    property bool isEmpty: sourceSize.width === 0
    property alias enableSwipe: idragHandler.enabled

    signal clicked
    signal doubleClicked
    signal swipeUp
    signal swipeDown
    signal swipeRight
    signal swipeLeft

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
    }

    fillMode: Image.PreserveAspectFit
    mipmap: true
    layer.enabled: !isEmpty
    layer.effect: OpacityMask {
        maskSource: Item {
            width: root.width
            height: root.height

            Rectangle {
                property real srcRatio: root.sourceSize.width
                                        > 0 ? root.sourceSize.height / root.sourceSize.width : 1
                property real ratio: !isEmpty ? parent.height / parent.width : 1

                anchors.centerIn: parent
                width: !isEmpty
                       && ratio < srcRatio ? parent.height / srcRatio : parent.width
                height: isEmpty
                        || ratio < srcRatio ? parent.height : parent.width * srcRatio
                radius: root.radius
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: showBackgroundWhenEmpty
               && isEmpty ? backgroundColor : "transparent"
        layer.enabled: color === backgroundColor
        layer.effect: OpacityMask {
            maskSource: Item {
                width: root.width
                height: root.height

                Rectangle {
                    anchors.fill: parent
                    radius: root.radius
                }
            }
        }

        TapHandler {
            onTapped: {
                root.clicked()
            }
            onDoubleTapped: {
                root.doubleClicked()
            }
        }
        DragHandler {
            id: idragHandler

            property real lastXtranslation
            property real lastYtranslation

            property real velocityX: 0
            property real velocityY: 0
            property bool tracing: false

            onTranslationChanged: {
                if (tracing) {
                    var currVelX = (translation.x - lastXtranslation)
                    var currVelY = (translation.y - lastYtranslation)
                    velocityX = (velocityX + currVelX) / 2.0
                    velocityY = (velocityY + currVelY) / 2.0
                    var hor = Math.abs(velocityX) >= Math.abs(velocityY)
                    if (hor && velocityX > 15) {
                        tracing = false
                        root.swipeRight()
                    } else if (hor && velocityX < -15) {
                        tracing = false
                        root.swipeLeft()
                    } else if (!hor && velocityY > 15) {
                        tracing = false
                        root.swipeDown()
                    } else if (!hor && velocityY < -15) {
                        tracing = false
                        root.swipeUp()
                    }
                }

                lastXtranslation = translation.x
                lastYtranslation = translation.y
            }
            onActiveChanged: {
                lastXtranslation = 0
                lastYtranslation = 0
                velocityX = 0
                velocityY = 0
                tracing = active
            }

            grabPermissions: touchInput ? PointerHandler.ApprovesTakeOverByAnything : PointerHandler.CanTakeOverFromItems
                                          | PointerHandler.CanTakeOverFromHandlersOfDifferentType
                                          | PointerHandler.ApprovesTakeOverByAnything
        }
    }
}
