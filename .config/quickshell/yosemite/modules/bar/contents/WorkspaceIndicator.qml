import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.modules.common

Rectangle {
    id: container
    color: Colors.surface_container
    radius: 999
    Layout.fillHeight: true
    Layout.alignment: Qt.AlignVCenter

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    // Build the display model: always 10, plus any extras
    property var displayWorkspaces: {
        let all = Hyprland.workspaces.values;
        let result = [];
        // Always show 1-10 (only real workspaces)
        for (let i = 1; i <= Config.options.persistentWorkspaceCount; ++i) {
            let ws = all.find(w => Number(w.name) === i && Number.isInteger(Number(w.name)) && Number(w.name) > 0);
            if (ws) {
                result.push(ws);
            } else {
                // Placeholder workspace
                result.push({
                    name: String(i),
                    id: "placeholder-" + i,
                    isPlaceholder: true
                });
            }
        }
        // Add any extra workspaces (not already included and not special)
        for (let ws of all) {
            let num = Number(ws.name);
            if ((!Number.isInteger(num) || num > Config.options.persistentWorkspaceCount) && !result.find(w => w.id === ws.id) && Number.isInteger(num) && num > 0) // Only add numbered workspaces
            {
                result.push(ws);
            }
        }
        return result;
    }

    // Calculate width: (N * size) + ((N-1) * spacing) + 2*margins
    property int wsCount: displayWorkspaces.length
    property int wsSize: height - 12
    property int wsSpacing: workspaceRow.spacing
    implicitWidth: workspaceRow.implicitWidth + 5

    RowLayout {
        id: workspaceRow
        anchors.fill: parent
        anchors.margins: 2
        spacing: 1

        Rectangle {
            Layout.fillHeight: true
            Layout.rightMargin: 3
            implicitWidth: height
            radius: 99
            color: Colors.primary
            MaterialIcon {
                anchors.centerIn: parent
                text: "dashboard"
                color: Colors.on_primary
                iconSize: 23
                filled: false
                weight: 400
            }
        }

        Repeater {
            model: container.displayWorkspaces
            Rectangle {
                Layout.fillHeight: true
                Layout.topMargin: 5
                Layout.bottomMargin: 5
                Layout.leftMargin: 3
                Layout.rightMargin: 3
                implicitWidth: height
                radius: height / 2

                // Scale and fade effect if focused
                scale: modelData.id === Hyprland.focusedWorkspace.id ? 1.25 : 1.0
                opacity: modelData.id === Hyprland.focusedWorkspace.id ? 1.0 : 0.7
                Behavior on scale {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.InOutQuad
                    }
                }

                // Determine color based on state
                color: modelData.isPlaceholder ? "#00000000" : (modelData.id === Hyprland.focusedWorkspace.id ? Colors.primary : Colors.surface_container_highest)

                Text {
                    anchors.centerIn: parent
                    text: modelData.name
                    color: modelData.isPlaceholder ? "#888" : (modelData.id === Hyprland.focusedWorkspace.id ? Colors.on_primary : Colors.on_surface)
                    font.pixelSize: 16
                    font.family: Config.options.fontFamily
                    font.bold: modelData.isPlaceholder ? false : true
                    scale: 1 / parent.scale // <-- This keeps the text size visually constant
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.isPlaceholder) {
                            Hyprland.dispatch("workspace " + modelData.name);
                        } else if (modelData.activate) {
                            modelData.activate();
                        }
                    }
                }
            }
        }
    }
}
