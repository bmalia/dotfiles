import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common

PanelWindow {
    id: barContainer
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: bar.implicitHeight + 18
    color: "transparent"

    // Only the bar's height is reserved as exclusive zone
    WlrLayershell.exclusiveZone: bar.implicitHeight

    RoundCorner {
        id: topLeftCorner
        corner: RoundCorner.CornerEnum.TopLeft
        anchors.top: bar.bottom
        anchors.left: bar.left
        implicitSize: 18
    }

    RoundCorner {
        id: topRightCorner
        corner: RoundCorner.CornerEnum.TopRight
        anchors.top: bar.bottom
        anchors.right: bar.right
        implicitSize: 18
    }
    
    Rectangle {
        implicitHeight: 50
        id: bar
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
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