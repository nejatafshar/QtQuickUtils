
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
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

Drawer {
    id: root

    property alias showHideState: imouseArea.state
    property bool autoHide: true
    property bool containsUnreadMessages: false
    property alias backgroundOpacity: ibackgroundRectangle.opacity
    property bool isOpen: imouseArea.state === "show"
    property bool openedByUser: false

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
        property int spacing: 0.04 * ppiz
        property int scrollBar: 0.1 * ppiz
        property int section: 0.5 * ppiz
        property int h2: typeof scl !== "undefined" ? scl.h2 : 14
        property int h3: typeof scl !== "undefined" ? scl.h3 : 12
        property int h4: typeof scl !== "undefined" ? scl.h4 : 10
    }

    function showMessage(message, icon, duration) {
        var d = new Date()
        ilistModel.insert(0, {
                              "message": message,
                              "icon": (icon === undefined ? "" : icon),
                              "time": d.toLocaleString(Qt.locale("en_US"),
                                                       "hh:mm:ss"),
                              "date": d.toLocaleString(Qt.locale("en_US"),
                                                       "ddd yyyy-MM-dd")
                          })
        ilistView.currentIndex = 0
        imouseArea.state = "show"
        if (autoHide && duration !== -1 && !openedByUser) {
            iautoHideTimer.interval = duration !== undefined
                    && duration > 0 ? duration : 10000
            iautoHideTimer.stop()
            iautoHideTimer.start()
        }
        containsUnreadMessages = true
    }
    function clearMessages() {
        ilistModel.clear()
        containsUnreadMessages = false
    }

    function openPanel() {
        openedByUser = true
        imouseArea.state = "hide"
        imouseArea.state = "show"
        containsUnreadMessages = false
    }
    function closePanel() {
        openedByUser = false
        ilistView.positionViewAtBeginning()
        imouseArea.state = "hide"
    }

    onAutoHideChanged: {
        if (!autoHide)
            iautoHideTimer.stop()
        else
            iautoHideTimer.start()
    }
    onClosed: {
        closePanel()
    }
    onOpened: {
        if (imouseArea.state === "hide")
            openPanel()
    }

    implicitWidth: internal.ppi * 3
    implicitHeight: internal.ppi * 2
    width: Math.min(implicitWidth, parent.width)
    height: Math.min(implicitHeight, parent.height)
    dim: false
    x: (parent.width - width) / 2
    z: 100
    edge: Qt.TopEdge
    position: 0
    closePolicy: Popup.NoAutoClose
    modal: false

    background: Rectangle {
        id: ibackgroundRectangle

        color: background1
        opacity: 0.7
        radius: internal.ppi * 0.05
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: root.width
                height: root.height
                radius: ibackgroundRectangle.radius
            }
        }

        Rectangle {
            width: parent.width
            height: internal.ppi * 0.05
            color: accent1
            anchors.bottom: parent.bottom
        }
    }

    Timer {
        id: iautoHideTimer

        onTriggered: {
            if (!imouseArea.containsMouse || deviceType === "mobile") {
                closePanel()
            } else
                iautoHideTimer.start()
        }

        interval: 5000
    }

    Row {
        id: iheaderRow

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: root.edge === Qt.BottomEdge ? parent.top : undefined
        anchors.topMargin: internal.ppi * 0.1
        anchors.bottom: root.edge === Qt.TopEdge ? parent.bottom : undefined
        anchors.bottomMargin: internal.ppi * 0.1
        spacing: internal.ppi * 0.1
        LayoutMirroring.enabled: typeof rightToLeft !== "undefined"
                                 && rightToLeft
        height: childrenRect.height

        Label {
            id: iicon

            text: ""
            font.family: fontAwesome.name
            font.pointSize: internal.h3
            anchors.verticalCenter: ititle.verticalCenter
        }
        Label {
            id: ititle

            text: qsTr("Messages")
            font.pointSize: internal.h3
            font.bold: true
        }
    }

    MouseArea {
        id: imouseArea

        onPositionChanged: {
            imouseArea.state = "show"
        }

        anchors.fill: parent
        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: true
        hoverEnabled: enabled
        state: "hide"
        enabled: state === "show"

        ListView {
            id: ilistView

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: root.edge === Qt.BottomEdge ? parent.bottom : undefined
            anchors.top: root.edge === Qt.TopEdge ? parent.top : undefined
            model: ilistModel
            delegate: idelegateComponent
            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: isectionComponent
            width: parent.width
            height: root.height - iheaderRow.height - internal.ppi * 0.23
            clip: true
            interactive: imouseArea.state === "show"
            spacing: internal.spacing
            ScrollBar.vertical: ScrollBar {
                width: implicitWidth / 3
                anchors.right: ilistView.right
                leftPadding: (-internal.scrollBar + internal.ppi * 0.1) * 0.5
                rightPadding: (-internal.scrollBar + internal.ppi * 0.1) * 0.5
                LayoutMirroring.enabled: typeof rightToLeft !== "undefined"
                                         && rightToLeft
                policy: ScrollBar.AlwaysOn
                visible: parent.contentHeight > parent.height
            }
            add: Transition {
                NumberAnimation {
                    properties: "x,y"
                    from: -internal.section
                    duration: 600
                    easing.type: Easing.OutCubic
                }
            }
            addDisplaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 600
                    easing.type: Easing.OutCubic
                }
            }
        }
        FontMetrics {
            id: fontMetrics
        }

        Component {
            id: idelegateComponent

            Row {
                anchors.left: parent.left
                anchors.leftMargin: internal.ppi * 0.1
                height: childrenRect.height
                spacing: internal.ppi * 0.1
                LayoutMirroring.enabled: typeof rightToLeft !== "undefined"
                                         && rightToLeft

                Label {
                    id: iiconLabel

                    text: icon
                    font.pointSize: index === 0 ? internal.h2 : internal.h3
                    font.family: fontAwesome.name
                    topPadding: internal.ppi * 0.03
                }
                Label {
                    text: message
                    font.pointSize: internal.h3
                    font.bold: index === 0
                    width: ilistView.width - iiconLabel.width - itimeLabel.width
                           - 2 * parent.spacing - 2 * parent.anchors.leftMargin
                    wrapMode: Text.Wrap
                }
                Label {
                    id: itimeLabel

                    text: time
                    font.pointSize: index === 0 ? internal.h3 : internal.h4
                    wrapMode: Text.Wrap
                }
            }
        }

        Component {
            id: isectionComponent

            Rectangle {
                width: parent.width
                height: internal.section * 0.6
                color: Material.accent

                Row {
                    anchors.centerIn: parent
                    height: childrenRect.height
                    spacing: internal.ppi * 0.1

                    Label {
                        text: ""
                        font.pointSize: internal.h2
                        font.family: fontAwesome.name
                        color: foreground2
                    }
                    Label {
                        text: section
                        font.pointSize: internal.h3
                        color: foreground2
                    }
                }
            }
        }

        ListModel {
            id: ilistModel
        }

        RoundButton {
            id: icloseButton

            onClicked: {
                containsUnreadMessages = false
                closePanel()
            }

            anchors.right: parent.right
            anchors.top: root.edge === Qt.BottomEdge ? parent.top : undefined
            anchors.bottom: root.edge === Qt.TopEdge ? parent.bottom : undefined
            font.family: fontAwesome.name
            font.pointSize: internal.h3
            text: ""
            flat: true
            padding: 0

            ToolTip {
                visible: parent.hovered
                text: qsTr("Close")
                delay: 200
                timeout: 2000
                font.bold: true
            }
        }

        RoundButton {
            id: iclearButton

            onClicked: clearMessages()

            text: ""
            font.family: fontAwesome.name
            font.pointSize: internal.h3
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            flat: true
            padding: 0
            enabled: ilistModel.count > 0

            ToolTip {
                visible: parent.hovered
                text: qsTr("Clear Messages")
                delay: 200
                timeout: 3000
                font.bold: true
            }
        }

        states: [
            State {
                name: "show"
            },
            State {
                name: "hide"
            }
        ]
        transitions: Transition {
            ScriptAction {
                script: {
                    if (imouseArea.state === "hide")
                        root.close()
                    else {
                        root.open()
                        iautoHideTimer.stop()
                    }
                }
            }
        }
    }

    Connections {
        target: scl
        function onZoomChanged() {
            ilistView.model = null
            ilistView.model = Qt.binding(function () {
                return ilistModel
            })
        }
    }
}
