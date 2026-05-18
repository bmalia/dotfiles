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
            color: "transparent"
            implicitHeight: 50

            Loader {
                active: true
                sourceComponent: BarContent {}
                anchors.fill: parent
            }
        }
    }
}
