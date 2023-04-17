
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: root

    property alias showToolButton: ishowToolButton

    signal focused

    onFocusChanged: {
        if (focus)
            focused()
    }

    echoMode: !ishowToolButton.checked ? TextInput.Password : TextInput.Normal
    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
    leftPadding: typeof rightToLeft !== "undefined"
                 && rightToLeft ? ishowToolButton.width : 0

    ToolButton {
        id: ishowToolButton

        text: ""
        font.family: fontAwesome.name
        font.pointSize: parent.font.pointSize
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        checkable: true
        focusPolicy: Qt.NoFocus
    }
}
