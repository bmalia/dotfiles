import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import qs.modules.bar.contents
import qs.modules.common
import Quickshell.Services.UPower

Rectangle {
    id: root
    width: 50
    height: 50
    color: "transparent"
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    property bool windowOnMonitor: Hyprland.toplevels.values.some(t => t.workspace.id === root.monitor.activeWorkspace?.id) // Ridiculously hacky, but it works (windows on workspaces that aren't visible still count as being "on" the monitor)

    property real focusT: windowOnMonitor ? 1 : 0
    Behavior on focusT {
        NumberAnimation {
            duration: 500
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
        }
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 5

        Item {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            Layout.preferredWidth: Math.max(0.0001, 1 - root.focusT)
        }

        Loader {
            sourceComponent: CookieButton {}
            Layout.fillHeight: true
            Layout.topMargin: 3
            Layout.bottomMargin: 3
        }

        Loader {
            sourceComponent: Workspaces {}
            Layout.fillHeight: true
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }

        Loader {
            sourceComponent: Clock {}
            Layout.fillHeight: true
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }

        Item {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            Layout.preferredWidth: Math.max(0.0001, root.focusT)
        }

        Loader {
            sourceComponent: Battery {}
            Layout.fillHeight: true
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            active: UPower.displayDevice.isLaptopBattery
        }

        Item {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            Layout.preferredWidth: Math.max(0.0001, 1 - root.focusT)
        }
    }
}
