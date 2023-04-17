
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Dialogs 1.3

Item {
    id: root

    property string title
    property var nameFilters: []
    property bool selectFolder: false
    property bool selectMultiple: false
    property bool selectExisting: true
    property string defaultSuffix
    property string folder

    signal accepted(var files)
    signal rejected

    function open() {
        ifileDialogLoader.sourceComponent = ifileDialogComponent
        ifileDialogLoader.item.open()
    }

    Component {
        id: ifileDialogComponent

        FileDialog {
            id: iopenDilaog

            onAccepted: {
                root.folder = folder
                root.accepted(fileUrls)
                ifileDialogLoader.sourceComponent = null
            }
            onRejected: {
                root.folder = folder
                root.rejected
                ifileDialogLoader.sourceComponent = null
            }

            title: root.title
            nameFilters: root.nameFilters
            selectFolder: root.selectFolder
            selectMultiple: root.selectMultiple
            selectExisting: root.selectExisting
            folder: root.folder
            defaultSuffix: root.defaultSuffix
        }
    }

    Loader {
        id: ifileDialogLoader
    }
}
