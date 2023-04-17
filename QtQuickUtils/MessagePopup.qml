
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

ExtendedDialog {
    id: root

    property alias text: imessageText.text

    property var acceptCallback: function () {}
    property var closeCallback: function () {}
    property var rejectCallback: function () {}

    function showMessage(message, acceptCB, closeCB, rejectCB) {
        text = message
        if (acceptCB === undefined)
            acceptCB = function () {}
        if (closeCB === undefined)
            closeCB = function () {}
        if (rejectCB === undefined)
            rejectCB = function () {}
        acceptCallback = acceptCB
        closeCallback = closeCB
        rejectCallback = rejectCB
        open()
    }

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
    }

    onAccepted: acceptCallback()
    onClosed: closeCallback()
    onRejected: rejectCallback()

    dialogTitle: qsTr("Warning")
    dialogIcon: ""
    standardButtons: Dialog.Ok
    implicitWidth: imessageText.implicitWidth + internal.ppi * 0.7
    implicitHeight: internal.ppiz * 8
    contentHeight: imessageText.height

    Label {
        id: imessageText

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.centerIn: parent
        width: Math.min(Math.min(implicitWidth, internal.ppiz * 8),
                        parent.width)
        height: contentHeight + internal.ppiz * 0.5
        wrapMode: Label.WordWrap
    }
}
