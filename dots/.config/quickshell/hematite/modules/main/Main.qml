import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.widgets
import qs.modules.common
import qs.modules.bar

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: root
        required property var modelData
        property int cornerSize: 30

        screen: modelData

        anchors {
            left: true
            right: true
            bottom: Config.options.bar.bottom
            top: !Config.options.bar.bottom
        }

        implicitHeight: modelData.height
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

            Loader {
                anchors.fill: parent
                sourceComponent: BarContent {}
            }
        }

        RoundCorner {
            anchors {
                bottom: Config.options.bar.bottom ? barBg.top : parent.bottom
                left: parent.left
            }
            implicitSize: root.cornerSize

            corner: RoundCorner.CornerEnum.BottomLeft
        }

        RoundCorner {
            anchors {
                bottom: Config.options.bar.bottom ? barBg.top : parent.bottom
                right: parent.right
            }
            implicitSize: root.cornerSize
            corner: RoundCorner.CornerEnum.BottomRight
        }

        RoundCorner {
            anchors {
                top: Config.options.bar.bottom ? parent.top : barBg.bottom
                left: parent.left
            }

            implicitSize: root.cornerSize

            corner: RoundCorner.CornerEnum.TopLeft
        }

        RoundCorner {
            anchors {
                top: Config.options.bar.bottom ? parent.top : barBg.bottom
                right: parent.right
            }

            implicitSize: root.cornerSize

            corner: RoundCorner.CornerEnum.TopRight
        }
    }
}
