pragma ComponentBehavior: Bound
import qs.services
import qs.modules.polkit
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    Loader {
        active: PolkitService.active
        sourceComponent: Variants {
            model: Quickshell.screens
            delegate: PanelWindow {
                id: panel
                required property var modelData
                screen: modelData
                color: "transparent"

                anchors {
                    top: true
                    left: true
                    right: true
                    bottom: true
                }

                WlrLayershell.namespace: "quickshell:polkit"
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
                exclusionMode: ExclusionMode.Ignore

                Loader {
                    id: contentLoader
                    z: 2
                    anchors.fill: parent
                    sourceComponent: PolkitContent {}
                }
            }
        }
    }
}
