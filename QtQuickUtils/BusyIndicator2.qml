
/****************************************************************************
** Copyright (C) 2021-present Nejat Afshar <nejatafshar@gmail.com>
** Distributed under the MIT License (http://opensource.org/licenses/MIT)
**
** This file is part of qtquick-utils.
** A collection of handy qml components.
****************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15

BusyIndicator {
    id: root

    contentItem: Item {
        implicitWidth: parent.width
        implicitHeight: parent.height

        Item {
            id: item
            width: parent.width
            height: parent.height
            opacity: root.running ? 1 : 0

            Behavior on opacity {
                OpacityAnimator {
                    duration: 250
                }
            }

            RotationAnimator {
                target: item
                running: root.visible && root.running
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1250
            }

            Repeater {
                id: repeater
                model: 6

                Rectangle {
                    id: rectangle
                    x: item.width / 2 - width / 2
                    y: item.height / 2 - height / 2
                    implicitWidth: item.width * 0.2
                    implicitHeight: item.width * 0.2
                    radius: implicitWidth / 2
                    color: foreground2
                    transform: [
                        Translate {
                            y: -Math.min(item.width,
                                         item.height) * 0.5 + rectangle.radius
                        },
                        Rotation {
                            angle: index / repeater.count * 360
                            origin.x: rectangle.radius
                            origin.y: rectangle.radius
                        }
                    ]
                }
            }
        }
    }
}
