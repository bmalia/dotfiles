import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.modules.common

Rectangle {
    id: root
    enum TileType {
        Toggle,
        Status
    }
    property int type: QuickSettingTile.TileType.Toggle
    property bool enabled: false
    property string icon: "close"
    property string label: "Setting"
    property string subtext: ""
    property bool iconFilled: false

    signal toggled(bool newState)

    signal actionClicked

    height: content.implicitHeight + 16
    color: switch (type) {
    case QuickSettingTile.TileType.Toggle:
        return enabled ? Colors.primary : Colors.surface_container;
    case QuickSettingTile.TileType.Status:
        return Colors.surface_container;
    }
    radius: enabled ? 20 : 999

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }
    Behavior on radius {
        NumberAnimation {
            duration: 200
        }
    }

    RowLayout {
        id: content
        z: 3
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        anchors.margins: 8
        spacing: 5

        Rectangle {
            id: iconContainer
            width: 55
            height: width
            color: root.enabled ? Colors.primary : Colors.surface_container
            radius: 15
            Layout.leftMargin: 0
            z: 4

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: QuickSettingTile.TileType.Status === root.type && root.enabled
                onClicked: root.actionClicked()
                cursorShape: Qt.PointingHandCursor
                z: 4
            }

            MaterialIcon {
                anchors.centerIn: parent
                text: icon
                color: root.enabled ? Colors.on_primary : Colors.on_surface_variant
                iconSize: 30
                filled: root.iconFilled

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }
        }

        ColumnLayout {
            spacing: 0
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true

            Text {
                text: label
                font.pixelSize: 16
                color: switch (type) {
                case QuickSettingTile.TileType.Toggle:
                    return root.enabled ? Colors.on_primary : Colors.on_surface_variant;
                case QuickSettingTile.TileType.Status:
                    return Colors.on_surface_variant;
                }
                font.family: Config.options.fontFamily
                font.bold: true
                elide: Text.ElideRight
                Layout.preferredWidth: root.width - iconContainer.width - 18

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }

            Text {
                visible: subtext !== ""
                text: subtext
                font.pixelSize: 13
                font.weight: Font.Medium
                color: switch (type) {
                case QuickSettingTile.TileType.Toggle:
                    return root.enabled ? Colors.on_primary : Colors.on_surface_variant;
                case QuickSettingTile.TileType.Status:
                    return Colors.on_surface_variant;
                }
                font.family: Config.options.fontFamily
                elide: Text.ElideMiddle
                Layout.preferredWidth: root.width - iconContainer.width - 18

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.enabled = !root.enabled;
            root.toggled(root.enabled);
        }
        z: 2
    }
}
