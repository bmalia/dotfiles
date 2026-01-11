import Quickshell
import Quickshell.Bluetooth
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets

Rectangle {
    anchors.fill: parent
    id: container
    Layout.minimumWidth: Config.btShowOnEmpty ? 0 : 40
    visible: Config.btShowOnEmpty ? true : adapterState === "connected"
    implicitWidth: visible ? (content.implicitWidth + (adapterState === "connected" ? 10 : 10)) : 0
    // implicitHeight: visible ? (content.implicitHeight + 10) : 0
    color: adapterState === "connected" ? Colors.primary_container : "transparent"
    radius: 99

    readonly property string adapterState: connectedDevices.length > 0 ? "connected" : Bluetooth.defaultAdapter.enabled ? "on" : "off"
    // Apparently Bluetooth.devices is actually a list of all devices the adapter can see, not just paired ones
    readonly property var connectedDevices: Bluetooth.devices ? Bluetooth.devices.values.filter(d => d.state === BluetoothDeviceState.Connected || d.state === BluetoothDeviceState.Connecting) : []

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 500
            easing.type: Easing.InOutBack
        }
    }

    RowLayout {
        id: content
        anchors.fill: parent
        spacing: 0
        MaterialIcon {
            Layout.leftMargin: 5
            text: container.adapterState === "connected" ? "bluetooth_connected" : container.adapterState === "on" ? "bluetooth" : "bluetooth_disabled"
            iconSize: 23
            color: container.adapterState === "connected" ? Colors.primary : container.adapterState === "on" ? Colors.on_surface : Colors.error
        }
        Repeater {
            model: container.connectedDevices
            Layout.rightMargin: 0
            delegate: Rectangle {
                height: 26
                width: batteryIndicator.width
                color: "transparent"
                radius: 999

                WavyCircularProgress {
                    id: batteryIndicator
                    progress: modelData.batteryAvailable ? modelData.battery : 0
                    color: modelData.batteryAvailable && modelData.battery < 0.2 ? Colors.error : Colors.secondary
                    diameter: 26
                    thickness: 2.5
                    scrollSpeed: modelData.state === BluetoothDeviceState.Connecting ? -0.15 : 0
                    waveAmplitude: modelData.state === BluetoothDeviceState.Connecting ? 1 : 0
                    waveCount: 8
                    centerItem: MaterialIcon {
                        text: fetchDeviceIcon(modelData.icon)
                        color: Colors.on_surface
                        iconSize: 16
                        weight: 500
                        filled: true
                    } 
                }
            }
        }
    }

    function fetchDeviceIcon(deviceIcon) {
        if (deviceIcon.includes("phone"))
            return "mobile";
        if (deviceIcon.includes("computer"))
            return "computer";
        if (deviceIcon.includes("gaming"))
            return "stadia_controller";
        if (deviceIcon.includes("headset"))
            return "headphones";
        if (deviceIcon.includes("mouse"))
            return "mouse";
        if (deviceIcon.includes("keyboard"))
            return "keyboard";
        return "settings_bluetooth";
    }
        
}
