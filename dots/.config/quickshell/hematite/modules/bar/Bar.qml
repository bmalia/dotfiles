pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common

Variants {
    model: Quickshell.screens

    delegate: Component {
        PanelWindow {
            id: root
            required property var modelData
            readonly property var barContentItem: content

            screen: modelData
            anchors {
                top: !Config.options.bar.bottom
                left: true
                right: true
                bottom: Config.options.bar.bottom
            }
            color: "transparent"
            implicitHeight: 55
            mask: barContentItem ? barContentItem.barMask : null

            BarContent {
                id: content
                anchors.fill: parent
            }
        }
    }
}
