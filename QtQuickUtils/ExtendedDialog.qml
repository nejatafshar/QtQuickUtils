
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
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Dialog {
    id: root

    property alias dialogTitle: ititle.text
    property alias dialogIcon: iicon.text
    property alias dialogIconFont: iicon.font
    property alias headerExtraItem: iheaderExtraItem.data
    property bool movableByMouse: true
    property int closeButtonPosition: Qt.BottomRightCorner
    property bool headerLayoutMirroring: true
    property alias headerItem: iheaderItem
    property alias footerItem: ifooterItem

    function openDialog(par) {
        parent = (par !== undefined ? par : win.Overlay.overlay)
        root.open()
    }

    signal canceled

    onCanceled: close()
    onClosed: {
        x = Qt.binding(function () {
            return (parent.width - width) / 2
        })
        y = Qt.binding(function () {
            return (parent.height - height) / 2
        })
    }

    x: parent ? (parent.width - width) / 2 : 0
    y: parent ? (parent.height - height) / 2 : 0
    width: Math.min(implicitWidth + 2 * scl.margin,
                    parent ? parent.width : Number.MAX_VALUE)
    height: Math.min(Math.min(contentHeight + footer.height + header.height
                              + topPadding + internal.ppi * 0.03,
                              implicitHeight),
                     parent ? parent.height : Number.MAX_VALUE)

    closePolicy: standardButtons !== (Dialog.Yes | Dialog.No | Dialog.Cancel) ? Dialog.CloseOnEscape | Dialog.CloseOnPressOutside : Dialog.NoAutoClose
    modal: true
    dim: true
    standardButtons: Dialog.Close
    parent: Overlay.overlay
    leftPadding: visible && width < internal.ppi * 4 ? internal.ppi * 0.1 : 24
    rightPadding: leftPadding
    bottomPadding: 0

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
        property int margin: 0.1 * ppi
        property int button: ppi * 0.25 + (ppiz * 0.2)
        property real zoom: typeof scl !== "undefined" ? scl.zoom : 1
        property int h2: typeof scl !== "undefined" ? scl.h2 : 14
        property int h3: typeof scl !== "undefined" ? scl.h3 : 12
        property int h4: typeof scl !== "undefined" ? scl.h4 : 10
    }

    header: Item {
        id: iheaderItem

        width: parent.width
        height: visible ? internal.ppi * 0.025 + internal.ppiz * 0.05 * internal.zoom : 0
        LayoutMirroring.enabled: headerLayoutMirroring
        LayoutMirroring.childrenInherit: true

        Item {
            id: iheaderExtraItem

            width: contentChildren.width
            height: contentChildren.height
        }
        RowLayout {
            id: iheaderRow

            anchors.fill: parent
            anchors.topMargin: 0.03 * internal.ppi
            anchors.rightMargin: 2 * internal.margin
            anchors.leftMargin: 2 * internal.margin

            spacing: 2 * internal.margin

            Label {
                id: iicon

                font.family: fontAwesome.name
                font.pointSize: internal.h2
                Layout.alignment: Qt.AlignVCenter //ititle.verticalCenter
            }
            Label {
                id: ititle

                font.pointSize: internal.h3
                font.bold: true
                width: Math.min(
                           implicitWidth,
                           root.width - iicon.width - icloseToolButton.width - internal.ppiz * 0.5)
            }
            Item {
                Layout.fillWidth: true
            }
            ToolButton {
                id: icloseToolButton

                text: ""

                onClicked: reject()
                font.family: fontAwesome.name
                font.pointSize: internal.h4
                visible: closeButtonPosition === Qt.TopLeftCorner
            }
        }
        MouseArea {
            property point clickPos: Qt.point(1, 1)

            onPressed: clickPos = Qt.point(mouse.x, mouse.y)
            onPositionChanged: {
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                root.x += delta.x
                root.y += delta.y
            }

            width: root.width
            height: internal.ppiz * 0.25
            preventStealing: true
            enabled: movableByMouse
        }
    }

    Component {
        id: closeComponent

        Item {
            height: icloseButton.height

            Button {
                id: icloseButton

                onClicked: reject()

                visible: closeButtonPosition === Qt.BottomRightCorner
                LayoutMirroring.enabled: false
                anchors.right: parent.right
                anchors.rightMargin: internal.ppi * 0.2
                anchors.bottom: parent.bottom
                height: internal.button

                contentItem: Label {
                    text: qsTr("CLOSE")
                    color: Material.accent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: internal.h3
                    font.bold: true
                }

                flat: true
                Keys.onReturnPressed: accept()
                Keys.onEnterPressed: root.accept()
            }
        }
    }

    Component {
        id: okComponent

        Item {
            height: iokButton.height

            Button {
                id: iokButton

                Component.onCompleted: forceActiveFocus()
                onClicked: accept()
                Keys.onReturnPressed: accept()
                Keys.onEnterPressed: accept()

                LayoutMirroring.enabled: false
                anchors.right: parent.right
                anchors.rightMargin: internal.ppi * 0.2
                anchors.bottom: parent.bottom
                height: internal.button

                contentItem: Label {
                    text: qsTr("OK")
                    color: Material.accent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: internal.h3
                    font.bold: true
                }

                flat: true
            }
        }
    }

    Component {
        id: yesNoCancelComponent

        Item {
            height: icancelButton.height

            Row {
                id: irow

                LayoutMirroring.enabled: false
                anchors.right: parent.right
                anchors.rightMargin: internal.ppi * 0.2
                anchors.bottom: parent.bottom

                Button {

                    onClicked: reject()

                    contentItem: Label {
                        text: qsTr("NO")
                        color: Material.accent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: internal.h3
                        font.bold: true
                    }
                    flat: true
                    height: internal.button
                }
                Button {

                    Component.onCompleted: forceActiveFocus()
                    onClicked: accept()
                    Keys.onReturnPressed: accept()
                    Keys.onEnterPressed: accept()
                    Keys.onEscapePressed: root.canceled()

                    contentItem: Label {
                        text: qsTr("YES")
                        color: Material.accent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: internal.h3
                        font.bold: true
                    }
                    flat: true
                    height: internal.button
                }
                Button {
                    id: icancelButton

                    onClicked: root.canceled()

                    visible: standardButtons === (Dialog.Yes | Dialog.No | Dialog.Cancel)

                    contentItem: Label {
                        text: qsTr("CANCEL")
                        color: Material.accent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: internal.h3
                        font.bold: true
                    }
                    flat: true
                    height: internal.button
                }
            }
        }
    }

    footer: Item {
        id: ifooterItem

        height: visible ? internal.button : 0

        Loader {
            anchors.fill: parent
            sourceComponent: {
                if (standardButtons === (Dialog.Yes | Dialog.No)
                        || standardButtons === (Dialog.Yes | Dialog.No | Dialog.Cancel))
                    yesNoCancelComponent
                else if (standardButtons === Dialog.Ok)
                    okComponent
                else if (standardButtons === Dialog.Close)
                    closeComponent
                else
                    null
            }
        }
    }
}
