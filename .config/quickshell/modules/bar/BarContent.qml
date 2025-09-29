import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.modules.bar.contents
import qs.modules.bar.contents.media

Item {
    id: root
    property var bar
    anchors.fill: parent

    // Main bar layout for left/right modules
    RowLayout {
        id: barRow
        anchors.fill: parent

        // Left modules
        Loader {
            sourceComponent: WorkspaceIndicator {}
            Layout.fillHeight: true
            Layout.leftMargin: 5
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }
        Item {
            Layout.fillWidth: true
        }
        // Right modules

        Loader {
            sourceComponent: SystemTray {
                bar: root.bar
            }
            Layout.fillHeight: true
            Layout.rightMargin: 5
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }

        Loader {
            sourceComponent: Battery {}
            Layout.fillHeight: true
            Layout.rightMargin: 2
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }

        Loader {
            sourceComponent: Bluetooth {}
            Layout.fillHeight: true
            Layout.rightMargin: 5
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }
    }

    RowLayout {
        anchors.centerIn: parent
        Loader {
            sourceComponent: Media {}
            Layout.fillHeight: true
            Layout.rightMargin: 5
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }
        Loader {
            sourceComponent: Clock {}
            Layout.fillHeight: true
            Layout.rightMargin: 5
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }
    }
}
