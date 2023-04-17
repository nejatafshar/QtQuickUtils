
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Window 2.15

ExtendedDialog {
    id: root

    property string appName
    property string appVersion
    property string builtOn
    property string copyrightYears
    property string companyName
    property string appLogo
    property string companyLogo
    property string licenseFile
    property var materialTheme: win.Material.theme
    property color materialBackground: background1
    property alias textArea: itextArea

    implicitWidth: internal.ppiz * 10
    implicitHeight: internal.ppiz * 10
    contentHeight: iflow.height
    dialogTitle: qsTr("About") + " " + appName
    dialogIcon: ""
    Material.theme: materialTheme
    Material.background: materialBackground

    QtObject {
        id: internal

        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
        property int h4: typeof scl !== "undefined" ? scl.h4 : 10
    }

    ScrollBar {
        id: iscrollBar
        anchors.left: iflickable.right
        anchors.top: iflickable.top
        anchors.bottom: iflickable.bottom
        policy: ScrollBar.AlwaysOn
        visible: iflickable.interactive
    }
    Flickable {
        id: iflickable

        clip: true
        anchors.fill: parent
        interactive: contentHeight > height
        flickableDirection: Flickable.VerticalFlick
        contentWidth: parent.width
        contentHeight: iflow.height
        ScrollBar.vertical: iscrollBar

        Flow {
            id: iflow

            width: parent.width
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: true
            spacing: 0.04 * internal.ppiz

            Image {
                id: iappLogoImage

                source: appLogo
                fillMode: Image.PreserveAspectFit
                mipmap: true
                width: Math.min(parent.width, internal.ppiz * 2.5)
            }

            Column {

                width: Math.min(parent.width, internal.ppiz * 6.5)
                spacing: 0.08 * internal.ppiz

                Flow {
                    width: parent.width
                    spacing: 0.04 * internal.ppiz

                    Item {
                        width: childrenRect.width
                        height: icompanyLogoImage.height

                        Column {
                            anchors.verticalCenter: parent.verticalCenter

                            Label {
                                text: appName + " " + appVersion
                            }
                            Label {
                                text: qsTr("Built on") + " " + builtOn
                            }
                            Label {
                                text: qsTr("Copyright") + " " + copyrightYears
                                      + " " + companyName + "."
                            }
                            Label {
                                text: qsTr("All rights reserved.")
                            }
                        }
                    }
                    Item {
                        height: 1
                        width: internal.ppiz * 0.1
                    }
                    Image {
                        id: icompanyLogoImage

                        source: companyLogo
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        width: internal.ppiz * 1.5
                        height: internal.ppiz * 1.5
                    }
                }
                ScrollView {
                    id: iscrollView

                    clip: true
                    width: parent.width
                    height: internal.ppiz * 2
                    contentHeight: itextArea.height
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                    TextArea {
                        id: itextArea

                        font.pointSize: internal.h4
                        readOnly: true
                        wrapMode: TextEdit.WordWrap
                        text: {
                            var response = ""
                            var xhr = new XMLHttpRequest
                            xhr.open("GET", licenseFile)
                            xhr.onreadystatechange = function () {
                                if (xhr.readyState === XMLHttpRequest.DONE)
                                    response = xhr.responseText
                            }
                            xhr.send()
                            response
                        }
                        selectByMouse: false
                        selectByKeyboard: false
                        background: Rectangle {
                            color: background1
                        }
                    }
                }
            }
        }
    }
}
