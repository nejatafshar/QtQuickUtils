
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.15

ExtendedDialog {
    id: root

    property alias image: iimage
    property alias source: iimage.source
    property bool isEmpty: iimage.sourceSize.width === 0
    property real srcRatio: iimage.sourceSize.width
                            > 0 ? iimage.sourceSize.height / iimage.sourceSize.width : 1

    implicitWidth: (!isEmpty && iimage.sourceSize.height
                    < iimage.sourceSize.width ? iimage.sourceSize.width : implicitHeight
                                                / srcRatio) + leftPadding + rightPadding
    implicitHeight: internal.ppiz * 9
    contentHeight: (!isEmpty && iimage.sourceSize.height
                    > iimage.sourceSize.width ? iimage.sourceSize.height : width
                                                * srcRatio) + footer.height
    dialogTitle: qsTr("Preview of Image")
    dialogIcon: ""
    leftPadding: dpi * 0.1

    QtObject {
        id: internal

        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
        property int margin: 0.1 * ppiz
        property int h1: typeof scl !== "undefined" ? scl.h1 : 16
        property int h2: typeof scl !== "undefined" ? scl.h2 : 14
    }

    contentItem: Item {
        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: true

        Image {
            id: iimage

            visible: !izoomButton.checked
            fillMode: izoomButton.enabled ? Image.PreserveAspectFit : Image.Pad
            mipmap: izoomButton.enabled ? true : false
            anchors.fill: parent
        }
        Flickable {
            id: iflickable

            onVisibleChanged: {
                contentX = contentWidth / 2 - width / 2
                contentY = contentHeight / 2 - height / 2
            }

            anchors.fill: parent
            visible: izoomButton.checked
            clip: true
            contentWidth: Math.max(iimage.sourceSize.width, parent.width)
            contentHeight: Math.max(iimage.sourceSize.height, parent.height)
            interactive: contentHeight > height || contentWidth > width
            ScrollBar.horizontal: ScrollBar {
                policy: ScrollBar.AlwaysOn
                visible: parent.contentWidth > parent.width
            }
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
                visible: parent.contentHeight > parent.height
            }

            Image {
                id: iimage2

                source: iimage.source
                fillMode: Image.Pad
                anchors.centerIn: parent
            }
        }
    }

    ToolButton {
        id: izoomButton

        parent: footer
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 2 * internal.margin
        font.pointSize: izoomButton.checked ? internal.h1 : internal.h2
        font.family: fontAwesome.name
        text: ""
        checkable: true
        checked: false
        enabled: (iimage.sourceSize.width > iflickable.width
                  || iimage.sourceSize.height > iflickable.height)

        ToolTip {
            visible: parent.hovered
            text: parent.checked ? qsTr("Scale to fit") : qsTr("Show real size")
            delay: 200
            timeout: 3000
            font.bold: true
        }
    }
}
