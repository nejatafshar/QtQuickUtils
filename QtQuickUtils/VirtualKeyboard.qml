
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
import QtQuick.Window 2.15

InputPanel {
    id: inputPanel

    Component.onCompleted: VirtualKeyboardSettings.activeLocales = ["en_GB", "fa_FA"]

    z: state === "visible" || inputPanelTransition.running ? 1000002 : -1
    y: parent ? parent.height : 0
    anchors.left: parent ? parent.left : undefined
    anchors.right: parent ? parent.right : undefined
    parent: Window.contentItem

    states: State {

        name: "visible"
        when: enableVirtualKeyboard && inputPanel.active

        PropertyChanges {
            target: inputPanel
            y: parent.height - inputPanel.height
        }
    }
    transitions: Transition {
        id: inputPanelTransition

        from: ""
        to: "visible"
        reversible: true
        enabled: !VirtualKeyboardSettings.fullScreenMode

        ParallelAnimation {
            NumberAnimation {
                properties: "y"
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }

    Binding {
        target: InputContext
        property: "animating"
        value: inputPanelTransition.running
    }
}
