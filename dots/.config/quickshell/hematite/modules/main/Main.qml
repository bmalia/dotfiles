import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.widgets
import qs.modules.common
import qs.modules.bar

Variants {
    model: Quickshell.screens

    delegate: Scope {
        id: root
        required property var modelData
        property int cornerSize: 30

        PanelWindow {
            id: barWindow
            screen: root.modelData

            anchors {
                left: true
                right: true
                bottom: Config.options.bar.bottom
                top: !Config.options.bar.bottom
            }

            implicitHeight: barBg.implicitHeight + root.cornerSize
            color: "transparent"
            exclusiveZone: barBg.implicitHeight

            mask: Region {
                item: barBg
            }

            Rectangle {
                id: barBg
                anchors {
                    left: parent.left
                    right: parent.right
                    top: Config.options.bar.bottom ? undefined : parent.top
                    bottom: Config.options.bar.bottom ? parent.bottom : undefined
                }
                implicitHeight: 55
                color: Appearance.colors.background

                BarContent {
                    anchors.fill: parent
                }
            }

            RoundCorner {
                anchors {
                    top: Config.options.bar.bottom ? undefined : barBg.bottom
                    bottom: Config.options.bar.bottom ? barBg.top : undefined
                    left: parent.left
                }
                implicitSize: root.cornerSize
                corner: Config.options.bar.bottom ? RoundCorner.CornerEnum.BottomLeft : RoundCorner.CornerEnum.TopLeft
            }

            RoundCorner {
                anchors {
                    top: Config.options.bar.bottom ? undefined : barBg.bottom
                    bottom: Config.options.bar.bottom ? barBg.top : undefined
                    right: parent.right
                }
                implicitSize: root.cornerSize
                corner: Config.options.bar.bottom ? RoundCorner.CornerEnum.BottomRight : RoundCorner.CornerEnum.TopRight
            }
        }

        PanelWindow {
            id: cornerWindow
            screen: root.modelData

            anchors {
                left: true
                right: true
                bottom: !Config.options.bar.bottom
                top: Config.options.bar.bottom
            }

            implicitHeight: root.cornerSize
            exclusionMode: ExclusionMode.Ignore
            color: "transparent"

            mask: Region {}

            RoundCorner {
                anchors {
                    bottom: Config.options.bar.bottom ? undefined : parent.bottom
                    top: Config.options.bar.bottom ? parent.top : undefined
                    left: parent.left
                }
                implicitSize: root.cornerSize
                corner: Config.options.bar.bottom ? RoundCorner.CornerEnum.TopLeft : RoundCorner.CornerEnum.BottomLeft
            }

            RoundCorner {
                anchors {
                    bottom: Config.options.bar.bottom ? undefined : parent.bottom
                    top: Config.options.bar.bottom ? parent.top : undefined
                    right: parent.right
                }
                implicitSize: root.cornerSize
                corner: Config.options.bar.bottom ? RoundCorner.CornerEnum.TopRight : RoundCorner.CornerEnum.BottomRight
            }
        }
    }
}
