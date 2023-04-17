import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.15

Item {
    id: root

    property int currentIndex: -1
    property int currentCustomIndex: -1
    property color currentColor
    property string currentColorHex: colorToHex(currentColor)
    property alias buttonTooltip: ibuttonTooltip.text
    property alias button: ibutton
    property alias menu: imenu
    property var colors: [Material.color(
            Material.Teal, Material.Shade400), Material.color(Material.DeepOrange, Material.Shade400), Material.color(
            Material.Blue, Material.Shade400), Material.color(Material.Pink, Material.Shade400), Material.color(
            Material.DeepPurple, Material.Shade400), Material.color(Material.Amber, Material.Shade400), Material.color(
            Material.LightGreen, Material.Shade400), Material.color(Material.Cyan, Material.Shade400), Material.color(
            Material.Red, Material.Shade400), Material.color(Material.Yellow, Material.Shade400), Material.color(
            Material.Lime, Material.Shade400), Material.color(Material.Indigo, Material.Shade400), Material.color(
            Material.Brown, Material.Shade400), Material.color(Material.Purple, Material.Shade400), Material.color(
            Material.BlueGrey, Material.Shade400), Material.color(Material.Green, Material.Shade400), Qt.rgba(
            0, 0, 0), Material.color(Material.Grey,
                                     Material.Shade800), Material.color(Material.Grey, Material.Shade400), Qt.rgba(255, 255, 255)]
    property var customColors
    property bool coloredButton: true

    QtObject {
        id: internal

        property int ppi: typeof scl !== "undefined" ? scl.ppi : Screen.pixelDensity * 25.4
        property int ppiz: typeof scl !== "undefined" ? scl.dpiz : Screen.pixelDensity * 25.4
        property int h1: typeof scl !== "undefined" ? scl.h1 : 16

        property var customColors: ListModel {
            ListElement {
                colorVal: "transparent"
            }
            ListElement {
                colorVal: "transparent"
            }
            ListElement {
                colorVal: "transparent"
            }
        }
    }

    function colorToHex(color) {
        return "#" + Math.round(color.r * 255).toString(16).padStart(
                    2, '0') + Math.round(color.g * 255).toString(16).padStart(
                    2, '0') + Math.round(color.b * 255).toString(16).padStart(
                    2, '0')
    }

    function updateIndexes() {
        currentIndex = colors.indexOf(currentColor)
        if (customColors === undefined)
            customColors = []
        currentCustomIndex = customColors.indexOf(colorToHex(currentColor))
    }

    onCurrentColorChanged: updateIndexes()
    onCustomColorsChanged: {
        for (var i = 0; i < Math.min(customColors.length,
                                     internal.customColors.count); i++)
            internal.customColors.setProperty(i, "colorVal", customColors[i])
        updateIndexes()
    }

    signal colorSelected(var col)

    width: ibutton.width
    height: ibutton.height
    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    component ColorRectangle: Item {
        id: icolorRectangle

        property bool custom: false

        width: internal.ppiz * 0.4
        height: width

        MouseArea {
            id: imouseArea

            onClicked: {
                currentColor = !icolorRectangle.custom ? colors[index] : customColors[index]
                colorSelected(currentColor)
                imenu.close()
            }

            anchors.fill: parent
            hoverEnabled: true

            Rectangle {
                anchors.fill: parent
                radius: width * 0.2
                color: index === (!icolorRectangle.custom ? currentIndex : currentCustomIndex) ? Qt.lighter(Material.accent) : "transparent"

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: internal.ppiz * 0.03
                    anchors.topMargin: internal.ppiz * 0.03
                    scale: imouseArea.containsMouse ? 1.2 : 1
                    width: parent.width - internal.ppiz * 0.06
                    height: width
                    color: icolorRectangle.custom ? model.colorVal : colors[index]
                    radius: width * 0.2

                    Behavior on scale {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.InOutCubic
                        }
                    }
                }
            }
        }
    }

    ToolButton {
        id: ibutton

        onClicked: imenu.open()

        anchors.fill: parent
        checkable: imenu.visible
        checked: imenu.visible
        font.family: fontAwesome.name
        text: ""
        focus: true
        Material.foreground: coloredButton ? currentColor : ibutton.Material.foreground

        ToolTip {
            id: ibuttonTooltip

            visible: parent.hovered
            text: qsTr("Select Color")
            delay: 200
            timeout: 3000
            font.bold: true
        }

        Menu {
            id: imenu

            y: parent.y + parent.height
            width: icolumn.implicitWidth + internal.ppi * 0.2
            height: icolumn.height + internal.ppi * 0.2

            Column {
                id: icolumn

                x: internal.ppi * 0.1
                y: internal.ppi * 0.1
                LayoutMirroring.enabled: false
                LayoutMirroring.childrenInherit: true

                Grid {
                    columns: 5
                    rowSpacing: internal.ppi * 0.05
                    columnSpacing: internal.ppi * 0.05

                    Repeater {
                        property bool customColor: false

                        model: colors.length

                        delegate: ColorRectangle {}
                    }
                }

                Row {
                    spacing: internal.ppi * 0.05

                    Button {
                        id: icustomColorButton

                        onClicked: icolorDialog.open()

                        font.family: fontAwesome.name
                        font.pointSize: internal.h1
                        text: ""
                        width: height
                        anchors.verticalCenter: parent.verticalCenter

                        ToolTip {
                            visible: parent.hovered
                            text: qsTr("Custom Color")
                            delay: 200
                            timeout: 3000
                            font.bold: true
                        }

                        ColorDialog {
                            id: icolorDialog

                            property int customIndexToSet: 0

                            onAccepted: {
                                var col = colorToHex(icolorDialog.color)
                                internal.customColors.setProperty(
                                            customIndexToSet, "colorVal", col)
                                var list = customColors ? customColors : []
                                if (list.length < (customIndexToSet + 1))
                                    list.push(col)
                                else
                                    list[customIndexToSet] = col
                                customColors = list
                                customIndexToSet++
                                if (customIndexToSet >= 3)
                                    customIndexToSet = 0
                            }

                            title: qsTr("Please choose a color")
                        }
                    }
                    Grid {
                        id: icustomColorsGrid

                        property bool customColor: true

                        columns: 3
                        rowSpacing: internal.ppi * 0.05
                        columnSpacing: internal.ppi * 0.05
                        anchors.verticalCenter: parent.verticalCenter

                        Repeater {
                            model: internal.customColors

                            delegate: ColorRectangle {
                                custom: true
                            }
                        }
                    }
                }
            }
        }
    }
}
