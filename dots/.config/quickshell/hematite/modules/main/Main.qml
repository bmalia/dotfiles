import QtQuick
import Quickshell
import Quickshell.Wayland
import Hematite.Blobs
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
            anchors {
                top: false
                bottom: true
                left: true
                right: true
            }
            implicitHeight: this.screen.height
            WlrLayershell.layer: WlrLayer.Bottom
            color: "transparent"
            exclusiveZone: bar.height - 5
            BlobGroup {
                id: mainBlobGroup
                color: Appearance.colors.darkMode ? "black" : Appearance.colors.surface
                smoothing: 25
            }

            BlobInvertedRect {
                anchors.fill: parent
                group: mainBlobGroup
                radius: 30
                borderBottom: 10
                borderLeft: 5
                borderRight: 5
                borderTop: 5
            }

            BlobRect {
                id: bar
                group: mainBlobGroup
                width: parent.width
                height: 55
                radius: 20
                anchors.bottom: parent.bottom
            }
        }
    }
}
