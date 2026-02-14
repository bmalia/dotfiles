import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common

Variants {
    model: Quickshell.screens

    delegate: Component {
        PanelWindow {
            id: barContainer
            required property var modelData

            screen: modelData
            anchors {
                top: Config.options.barPosition == 0 ? true : false
                left: true
                right: true
                bottom: Config.options.barPosition == 1 ? true : false
            }
            implicitHeight: bar.implicitHeight + Config.options.barCornerSize
            WlrLayershell.layer: WlrLayer.Bottom
            color: "transparent"

            // Only the bar's height is reserved as exclusive zone
            WlrLayershell.exclusiveZone: bar.implicitHeight

            RoundCorner {
                id: leftCorner
                corner: Config.options.barPosition == 0 ? RoundCorner.CornerEnum.TopLeft : RoundCorner.CornerEnum.BottomLeft
                anchors.top: Config.options.barPosition == 0 ? bar.bottom : undefined
                anchors.left: bar.left
                anchors.bottom: Config.options.barPosition == 1 ? bar.top : undefined
                implicitSize: Config.options.barCornerSize
                visible: Config.options.barStyle == 0
            }

            RoundCorner {
                id: rightCorner
                corner: Config.options.barPosition == 0 ? RoundCorner.CornerEnum.TopRight : RoundCorner.CornerEnum.BottomRight
                anchors.top: Config.options.barPosition == 0 ? bar.bottom : undefined
                anchors.bottom: Config.options.barPosition == 1 ? bar.top : undefined
                anchors.right: bar.right
                implicitSize: Config.options.barCornerSize
                visible: Config.options.barStyle == 0
            }

            Rectangle {
                id: bar
                implicitHeight: 50
                anchors {
                    left: parent.left
                    right: parent.right
                    top: Config.options.barPosition == 0 ? parent.top : undefined
                    bottom: Config.options.barPosition == 1 ? parent.bottom : undefined
                }
                color: Colors.background
                anchors.margins: Config.options.barStyle == 1 ? 5 : 0
                radius: Config.options.barStyle == 1 ? 99 : 0

                Loader {
                    anchors.fill: parent
                    sourceComponent: BarContent {
                        bar: barContainer
                    }
                }
            }
        }
    }
}
