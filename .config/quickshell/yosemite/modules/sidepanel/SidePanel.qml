import qs.modules.sidepanel
import qs.modules.common
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: sidePanel
    implicitWidth: 400
    implicitHeight: screen.height - Config.barHeight
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
        anchors.margins: 11
        radius: Config.barCornerSize - 5

        Loader {
            id: sidePanelContentLoader
            anchors.fill: parent

            sourceComponent: PanelContent {}
        }
    }
}
