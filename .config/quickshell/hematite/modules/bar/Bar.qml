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
            readonly property var barContentItem: contentLoader.item

            screen: modelData
            anchors {
                top: Config.options.barPosition == 0 ? true : false
                left: true
                right: true
                bottom: Config.options.barPosition == 1 ? true : false
            }
            color: "transparent"
            implicitHeight: 45
            mask: contentLoader.item ? barContentItem.barMask : null

            Loader {
                id: contentLoader
                active: true
                sourceComponent: BarContent {
                }
                anchors.fill: parent
            }
        }
    }
}
