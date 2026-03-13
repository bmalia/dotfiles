import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Layouts
import qs.modules.common
import qs.services
import "../../widgets/shapes/material-shapes.js" as MaterialShapes

Rectangle {
    id: root
    width: Config.options.workspaceCount * 27 + 10
    color: Appearance.colors.background
    radius: 99
    property list<bool> occupied: []
    property int previousWorkspaceId: 1
    property int delta: 0
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    readonly property int effectiveActiveWorkspaceId: monitor?.activeWorkspace?.id ?? 1
    readonly property int workspaceGroup: Math.floor((effectiveActiveWorkspaceId - 1) / Config.options.workspaceCount)

    onEffectiveActiveWorkspaceIdChanged: {
        if (effectiveActiveWorkspaceId != previousWorkspaceId) {
            if (effectiveActiveWorkspaceId > previousWorkspaceId) {
                CookieButtonState.setTransientShape(MaterialShapes.getArrow(), 90);
            } else if (effectiveActiveWorkspaceId < previousWorkspaceId) {
                CookieButtonState.setTransientShape(MaterialShapes.getArrow(), -90);
            }
        }
        previousWorkspaceId = effectiveActiveWorkspaceId;
    }

    function updateOccupied() {
        occupied = Array.from({
            length: Config.options.workspaceCount
        }, (_, i) => {
            return Hyprland.workspaces.values.some(ws => ws.id === workspaceGroup * Config.options.workspaceCount + i + 1);
        });
    }

    // Occupied workspace updates
    Component.onCompleted: {
        previousWorkspaceId = effectiveActiveWorkspaceId;
        delta = 0;
        updateOccupied();
        width = Config.options.workspaceCount * 27 + 10;
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

    RowLayout {
        id: row
        z: 3
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 5
        spacing: 0
    }
    
    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y < 0)
                Hyprland.dispatch(`workspace r+1`);
            else if (event.angleDelta.y > 0)
                Hyprland.dispatch(`workspace r-1`);
        }
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    Item {
        anchors.fill: parent

        // Background
        RowLayout {
            id: bgRow
            z: 0
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 5
            spacing: 0

            Repeater {
                model: Config.options.workspaceCount
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

                    color: root.occupied[index] ? Appearance.colors.surface_container : "transparent"
                }
            }
        }

        // Active indicator
        Rectangle {
            id: indicator
            z: 1
            color: Appearance.colors.primary
            width: 24
            height: 24
            radius: 99
            anchors.verticalCenter: bgRow.verticalCenter
            x: 10 + (root.effectiveActiveWorkspaceId - 1 - root.workspaceGroup * Config.options.workspaceCount) * 26

            Behavior on x {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                }
            }
        }

        // Workspace numbers
        RowLayout {
            id: textRow
            z: 2
            anchors.fill: bgRow
            spacing: 0

            Repeater {
                model: Config.options.workspaceCount
                delegate: Rectangle {
                    z: 2
                    required property int index
                    property int actualIndex: index + 1 + root.workspaceGroup * Config.options.workspaceCount
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

                        font.family: Appearance.fontFamily
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
                            Hyprland.dispatch("workspace " + actualIndex);
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}
