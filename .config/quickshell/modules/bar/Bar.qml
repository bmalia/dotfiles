import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs

PanelWindow {
    id: barContainer
    anchors {
        top: Config.barPosition === "top" ? true : undefined
        left: true
        right: true
        bottom: Config.barPosition === "bottom" ? true : undefined
    }
    implicitHeight: bar.implicitHeight + Config.barCornerSize
    color: "transparent"

    // Only the bar's height is reserved as exclusive zone
    WlrLayershell.exclusiveZone: bar.implicitHeight

    RoundCorner {
        id: leftCorner
        corner: Config.barPosition === "top" ? RoundCorner.CornerEnum.TopLeft : RoundCorner.CornerEnum.BottomLeft
        anchors.top: Config.barPosition === "top" ? bar.bottom : undefined
        anchors.left: bar.left
        anchors.bottom: Config.barPosition === "bottom" ? bar.top : undefined
        implicitSize: Config.barCornerSize
    }

    RoundCorner {
        id: rightCorner
        corner: Config.barPosition === "top" ? RoundCorner.CornerEnum.TopRight : RoundCorner.CornerEnum.BottomRight
        anchors.top: Config.barPosition === "top" ? bar.bottom : undefined
        anchors.bottom: Config.barPosition === "bottom" ? bar.top : undefined
        anchors.right: bar.right
        implicitSize: Config.barCornerSize
    }

    Rectangle {
        id: bar
        implicitHeight: Config.barHeight
        anchors {
            left: parent.left
            right: parent.right
            top: Config.barPosition === "top" ? parent.top : undefined
            bottom: Config.barPosition === "bottom" ? parent.bottom : undefined
        }
        color: Colors.background

        Loader {
            anchors.fill: parent
            sourceComponent: BarContent {
                bar: barContainer
            }
        }
    }
}
