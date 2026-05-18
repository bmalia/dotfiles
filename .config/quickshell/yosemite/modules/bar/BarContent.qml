import QtQuick
import Quickshell
import qs.modules.widgets
import Quickshell.Hyprland
import QtQuick.Layouts
import qs.modules.bar.contents
import qs.modules.common
import qs.services
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray

Rectangle {
    id: root
    width: 50
    height: 70
    color: "transparent"
    clip: true
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    property bool windowOnMonitor: Hyprland.toplevels.values.some(t => t.workspace.id === root.monitor.activeWorkspace?.id) // Ridiculously hacky, but it works (windows on workspaces that aren't visible still count as being "on" the monitor)
    readonly property real middleWidth: middleContent.implicitWidth
    readonly property real collapsedMiddleLeft: layout.x + middleSlot.x
    readonly property real expandedMiddleLeft: (root.width - root.middleWidth) / 2

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

        Item { // Left spacer
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            Layout.preferredWidth: Math.max(0.0001, 1 - root.focusT)
        }

        Loader {
            sourceComponent: CookieButton {}
            active: true
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

        Item { // Middle-left spacer
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            Layout.preferredWidth: Math.max(0.0001, root.focusT)
            visible: root.focusT > 0
        }

        Item { // Placeholder matcher for middle content
            id: middleSlot
            Layout.fillHeight: true
            Layout.minimumWidth: root.middleWidth
            Layout.preferredWidth: root.middleWidth
            visible: root.middleWidth > 0
        }

        Item { // Middle-right spacer
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            Layout.preferredWidth: Math.max(0.0001, root.focusT)
            visible: root.focusT > 0
        }

        AnimatedLoader {
            shouldShow: SystemTray.items.values.length > 0
            sourceComponent: SysTray {}
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }

        Loader {
            sourceComponent: System {}
            Layout.fillHeight: true
            Layout.topMargin: 5
            Layout.bottomMargin: 5
        }

        Item { // Right spacer
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            Layout.preferredWidth: Math.max(0.0001, 1 - root.focusT)
        }
    }

    Rectangle {
        id: middleSection
        z: 10
        y: 0
        width: root.middleWidth
        anchors {
            top: parent.top
            bottom: parent.bottom
        }
        x: root.collapsedMiddleLeft + (root.expandedMiddleLeft - root.collapsedMiddleLeft) * root.focusT
        color: "transparent"

        RowLayout {
            id: middleContent
            anchors.fill: parent
            spacing: layout.spacing

            AnimatedLoader {
                shouldShow: !!MprisController.activePlayer
                sourceComponent: Media {}
                Layout.topMargin: 5
                Layout.bottomMargin: 5
            }
        }
    }
}
