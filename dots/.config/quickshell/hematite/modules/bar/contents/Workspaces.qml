import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Layouts
import qs.modules.common
import qs.services
import Hematite.Blobs

Rectangle {
    id: root
    implicitWidth: Config.options.bar.workspaces.count * 30
    color: "transparent"

    property list<bool> occupied: []
    property int previousWorkspaceId: 1
    property int delta: 0
    property bool isAnimating: false
    required property BlobGroup blobGroup
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    readonly property int effectiveActiveWorkspaceId: monitor?.activeWorkspace?.id ?? 1
    readonly property int workspaceGroup: Math.floor((effectiveActiveWorkspaceId - 1) / Config.options.bar.workspaces.count)

    onEffectiveActiveWorkspaceIdChanged: {
        previousWorkspaceId = effectiveActiveWorkspaceId;
        root.isAnimating = true;
        blobAnimTimer.restart();
    }

    function updateOccupied() {
        occupied = Array.from({
            length: Config.options.bar.workspaces.count
        }, (_, i) => {
            return Hyprland.workspaces.values.some(ws => ws.id === workspaceGroup * Config.options.bar.workspaces.count + i + 1);
        });
    }

    Timer {
        id: blobAnimTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            root.isAnimating = false;
        }
    }

    // Occupied workspace updates
    Component.onCompleted: {
        previousWorkspaceId = effectiveActiveWorkspaceId;
        delta = 0;
        updateOccupied();
        width = Config.options.bar.workspaces.count * 27 + 10;
    }
    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            root.updateOccupied();
        }
    }
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            root.updateOccupied();
        }
    }

    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y < 0)
                Hyprland.dispatch("hl.dsp.focus({workspace = \"+1\"})");
            else if (event.angleDelta.y > 0)
                Hyprland.dispatch("hl.dsp.focus({workspace = \"-1\"})");
        }
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    Item {
        anchors.fill: parent

        // Background
        RowLayout {
            id: bgRow
            z: 1
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 2
            spacing: 0

            Repeater {
                model: Config.options.bar.workspaces.count
                delegate: Rectangle {
                    z: 0
                    required property int index
                    Layout.fillHeight: true
                    Layout.topMargin: 2
                    Layout.bottomMargin: 2
                    implicitWidth: height

                    property var previousOccupied: root.occupied[index - 1]
                    property var rightOccupied: root.occupied[index + 1]
                    property var radiusPrev: previousOccupied ? 0 : (width / 2)
                    property var radiusNext: rightOccupied ? 0 : (width / 2)

                    topLeftRadius: radiusPrev
                    bottomLeftRadius: radiusPrev
                    topRightRadius: radiusNext
                    bottomRightRadius: radiusNext

                    color: root.occupied[index] ? Qt.alpha(Appearance.colors.surface_container, Config.options.backgroundOpacity) : "transparent"
                }
            }
        }

        // Active indicator
        Rectangle {
            id: indicator
            z: 2
            color: Appearance.colors.primary
            width: 24
            height: 24
            radius: 99
            anchors.verticalCenter: bgRow.verticalCenter
            x: 4 + (root.effectiveActiveWorkspaceId - 1 - root.workspaceGroup * Config.options.bar.workspaces.count) * 29.5

            Behavior on x {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                }
            }
        }

        BlobRect {
            z: 0
            group: root.blobGroup
            x: indicator.x + (indicator.width / 2) - (width / 2)
            y: root.isAnimating ? indicator.y - 15: 0
            width: root.isAnimating ? 5 : 0
            height: root.isAnimating ? 20 : 0
            radius: 99

            Behavior on y {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on width {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on height {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Workspace numbers
        RowLayout {
            id: textRow
            z: 3
            anchors.fill: bgRow
            spacing: 0

            Repeater {
                model: Config.options.bar.workspaces.count
                delegate: Rectangle {
                    z: 2
                    required property int index
                    property int actualIndex: index + 1 + root.workspaceGroup * Config.options.bar.workspaces.count
                    Layout.fillHeight: true
                    Layout.topMargin: 2
                    Layout.bottomMargin: 2
                    implicitWidth: height

                    color: "transparent"

                    Text {
                        z: 3
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 1
                        text: actualIndex
                        color: root.effectiveActiveWorkspaceId === actualIndex ? Appearance.colors.on_primary : root.occupied[index] ? Appearance.colors.on_surface : Qt.alpha(Appearance.colors.on_surface_variant, 0.4)

                        font.family: Config.options.fontFamily
                        font.bold: root.occupied[index]
                        font.pixelSize: 14

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Appearance.easings.expressiveDefaultEffects
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Hyprland.dispatch("hl.dsp.focus({workspace = " + actualIndex + "})");
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}
