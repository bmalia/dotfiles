import Quickshell
import QtQuick
import qs.modules.common
import qs.modules.widgets

Variants {
    model: Quickshell.screens

    delegate: Component {
        PanelWindow {
            id: root

            property bool expanded: false
            property bool collapsed: false

            required property var modelData
            screen: modelData

            anchors {
                top: !Config.options.bar.bottom
                bottom: Config.options.bar.bottom
                left: true
                right: true
            }
            exclusionMode: ExclusionMode.Ignore
            implicitHeight: 700
            color: "transparent"

            mask: Region {
                item: island

                Region {
                    item: leftRound
                }

                Region {
                    item: rightRound
                }
            }

            Rectangle {
                id: island
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }

                property real popWidth: 0

                implicitWidth: root.expanded ? 600 + popWidth : 150 + popWidth
                implicitHeight: root.expanded ? 250 + popWidth : 45 + popWidth
                color: Appearance.colors.background
                bottomLeftRadius: 45
                bottomRightRadius: 45

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: root.expanded = !root.expanded
                    onEntered: island.popWidth = 10
                    onExited: island.popWidth = 0
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 450
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                    }
                }

                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                    }
                }

                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }

                Text {
                    anchors.centerIn: parent
                    text: Qt.formatTime(clock.date, "hh:mm AP")
                    color: Appearance.colors.on_surface
                    font {
                        family: Config.options.fontFamily
                        pixelSize: 16
                        bold: true
                    }
                }
            }

            RoundCorner {
                id: leftRound
                anchors {
                    top: parent.top
                    right: island.left
                }
                corner: RoundCorner.CornerEnum.TopRight
                implicitSize: Math.min(island.implicitHeight * 0.5, 40)
                color: Appearance.colors.background
            }

            RoundCorner {
                id: rightRound
                anchors {
                    top: parent.top
                    left: island.right
                }
                corner: RoundCorner.CornerEnum.TopLeft
                implicitSize: Math.min(island.implicitHeight * 0.5, 40)
                color: Appearance.colors.background
            }
        }
    }
}
