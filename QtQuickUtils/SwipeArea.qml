
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15

MouseArea {
    id: root

    property real prevX: 0
    property real prevY: 0
    property real velocityX: 0.0
    property real velocityY: 0.0
    property bool tracing: false

    signal swipeLeft
    signal swipeRight
    signal swipeUp
    signal swipeDown

    onPressed: {
        prevX = mouseX
        prevY = mouseY
        velocityX = 0
        velocityY = 0
        tracing = true
    }

    onPositionChanged: {
        if (!tracing || mouseX > width || mouseX < 0 || mouseY > height
                || mouseY < 0)
            return

        var currVelX = (mouseX - prevX)
        var currVelY = (mouseY - prevY)

        velocityX = (velocityX + currVelX) / 2.0
        velocityY = (velocityY + currVelY) / 2.0

        prevX = mouseX
        prevY = mouseY

        var hor = Math.abs(velocityX) >= Math.abs(velocityY)

        if (hor && velocityX > 15 && mouseX > root.width * 0.25) {
            tracing = false
            root.swipeRight()
        } else if (hor && velocityX < -15 && mouseX < root.width * 0.75) {
            tracing = false
            root.swipeLeft()
        } else if (!hor && velocityY > 15 && mouseY > root.height * 0.25) {
            tracing = false
            root.swipeDown()
        } else if (hor && velocityY < -15 && mouseY < root.height * 0.75) {
            tracing = false
            root.swipeUp()
        }
    }
}
