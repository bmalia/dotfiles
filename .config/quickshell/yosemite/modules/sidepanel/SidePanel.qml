import qs.modules.sidepanel
import qs.modules.common
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: sidePanel
    width: 350
    height: screen.height - Config.barHeight
    anchors {
        top: true
        right: true
        bottom: false
    }
    WlrLayershell.layer: WlrLayer.Overlay
    color: "transparent"

    Rectangle {
        id: panelBackground
        width: sidePanel.width
        height: sidePanel.height - 10
        color: Colors.background
        anchors.fill: parent
        anchors.margins: 5
        radius: Config.barCornerSize

        Loader {
            id: sidePanelContentLoader
            anchors.fill: parent

            sourceComponent: PanelContent {}
        }
    }
}
