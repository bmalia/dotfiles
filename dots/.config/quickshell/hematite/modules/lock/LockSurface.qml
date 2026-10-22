import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import "../widgets/shapes/material-shapes.js" as MaterialShapes
import qs.modules.bar.contents
import qs.modules.widgets.shapes
import Quickshell.Services.UPower
import Quickshell.Widgets
import qs.modules.common

Rectangle {
    id: root
    required property LockContext context

    Image {
        id: wallpaper
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Appearance.colors.wallpaper
    }

    Button {
        id: debugUnlock
        text: "Let me out"
        onClicked: {
            GlobalVars.persistent.screenLocked = false;
            root.context.unlocked();
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        RowLayout {
            spacing: 20

            Item {
                implicitHeight: 300
                implicitWidth: 300

                ShapeCanvas {
                    implicitHeight: 300
                    implicitWidth: 300
                    anchors.centerIn: parent
                    color: Appearance.colors.tertiary_container
                    roundedPolygon: MaterialShapes.getCookie12Sided()

                    Rectangle { // Hour
                        width: 30
                        anchors.bottom: parent.verticalCenter
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 60
                        color: Appearance.colors.on_tertiary_container
                        radius: 90
                        bottomLeftRadius: 0
                        bottomRightRadius: 0
                        rotation: clock.date.getHours() * 30 + clock.date.getMinutes() * 0.5
                        transformOrigin: Item.Bottom
                        z: 3

                        Behavior on rotation {
                            RotationAnimation {
                                direction: RotationAnimation.Clockwise
                                duration: 350
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                            }
                        }
                    }

                    Rectangle { // Minute
                        width: 10
                        anchors.bottom: parent.verticalCenter
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 20
                        color: Appearance.colors.tertiary
                        radius: 10
                        rotation: clock.date.getMinutes() * 6
                        transformOrigin: Item.Bottom
                        z: 1

                        Behavior on rotation {
                            RotationAnimation {
                                direction: RotationAnimation.Clockwise
                                duration: 350
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                            }
                        }
                    }

                    Rectangle { // Centerpiece
                        implicitHeight: implicitWidth
                        implicitWidth: 30
                        anchors.centerIn: parent
                        color: Appearance.colors.on_tertiary_container
                        radius: 100
                        z: 2
                    }

                    Item { // Seconds
                        implicitWidth: 20
                        anchors.bottom: parent.verticalCenter
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 25
                        transformOrigin: Item.Bottom
                        rotation: clock.date.getSeconds() * 6

                        Rectangle {
                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                            }
                            implicitHeight: 20
                            color: Appearance.colors.on_tertiary_container
                            radius: 100
                        }
                    }

                    SystemClock {
                        id: clock
                        precision: SystemClock.Seconds
                    }
                }
            }

            ColumnLayout {
                implicitHeight: 300
                implicitWidth: 150
                spacing: 10

                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: 150
                    radius: 99
                    color: Appearance.colors.surface

                    Text {
                        text: `${String((clock.date.getHours() % 12) || 12).padStart(2, "0")}\n${Qt.formatTime(clock.date, "mm")}` // Workaround
                        color: Appearance.colors.primary
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                        lineHeight: 0.8
                        font.pixelSize: batteryLoader.visible ? 65 : 75
                        font.family: "Space Grotesk"
                        font.variableAxes: {
                            "wght": 700
                        }
                    }
                }

                Rectangle {
                    implicitHeight: 50
                    implicitWidth: 150
                    radius: 20
                    color: Appearance.colors.surface

                    Text {
                        anchors.centerIn: parent
                        text: Qt.formatDate(clock.date, "ddd, MMM d")
                        color: Appearance.colors.on_surface
                        font {
                            family: Config.options.fontFamily
                            pixelSize: 18
                            bold: true
                        }
                    }
                }

                Loader {
                    id: batteryLoader
                    height: 45
                    Layout.alignment: Qt.AlignHCenter
                    visible: UPower.displayDevice.isLaptopBattery
                    active: visible
                    sourceComponent: Battery {}

                    Layout.maximumWidth: parent.implicitWidth
                }
            }
        }
    }
}
