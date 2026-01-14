import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.modules.widgets
import qs.services

Rectangle {
    id: quickSettings
    width: parent.width
    color: Colors.surface_container_lowest
    height: settingsGrid.implicitHeight + 20

    radius: 20

    GridLayout {
        id: settingsGrid
        anchors.fill: parent
        anchors.margins: 10
        rowSpacing: 5
        columnSpacing: 5
        columns: 2

        QuickSettingTile {
            Layout.fillWidth: true
            type: QuickSettingTile.TileType.Status
            icon: Network.wifiStatus === "disconnected" ? "signal_wifi_bad" : Network.wifiStatus === "connecting" ? "cached" : Network.materialSymbol
            label: "Network"
            subtext: Network.wifiStatus === "connected" ? Network.networkName : Network.wifiStatus === "disabled" ? "Disabled" : "Not Connected"
            enabled: Network.wifiStatus !== "disabled"
            onActionClicked: {
                Quickshell.execDetached([]);
            }
            onToggled: (newState) => {
                Network.toggleWifi();
            }
        }

        QuickSettingTile {
            Layout.fillWidth: true
            type: QuickSettingTile.TileType.Status
            icon: BtService.materialSymbol
            label: "Bluetooth"
            subtext: BtService.btStatus === "connected" ? BtService.exposedDevice.name : BtService.btStatus === "on" ? "On" : ""
            enabled: BtService.btStatus !== "off"
            onActionClicked: {
                Quickshell.execDetached(["blueberry"]);
            }
            onToggled: (newState) => {
                BtService.toggleBluetooth();
            }
        }

        QuickSettingTile {
            Layout.fillWidth: true
            type: QuickSettingTile.TileType.Toggle
            icon: "dark_mode"
            label: "Dark Mode"
            // subtext: Colors.darkMode ? "Enabled" : "Disabled"
            enabled: Colors.darkMode
            iconFilled: Colors.darkMode

            onToggled: (newState) => {
                Quickshell.execDetached(["yosemite", "appearance", "toggle"]);
            }
        }

        QuickSettingTile {
            Layout.fillWidth: true
            type: QuickSettingTile.TileType.Toggle
            icon: "coffee"
            label: "Caffinate"
            subtext: "Not supported"
        }
    }
}