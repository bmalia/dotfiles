pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Bluetooth

Singleton {
    id: bluetoothService
    
    property string btStatus: connectedDevices.length > 0 ? "connected" : Bluetooth.defaultAdapter.enabled ? "on" : "off"
    // Apparently Bluetooth.devices is actually a list of all devices the adapter can see, not just paired ones
    property var devices: Bluetooth.devices
    property var connectedDevices: Bluetooth.devices ? Bluetooth.devices.values.filter(d => d.state === BluetoothDeviceState.Connected || d.state === BluetoothDeviceState.Connecting) : []
    property string materialSymbol: btStatus === "connected" ? "bluetooth_connected" : btStatus === "on" ? "bluetooth" : "bluetooth_disabled"
    property BluetoothDevice exposedDevice: connectedDevices.length > 0 ? connectedDevices[0] : null
    property bool scanning: false

    function toggleBluetooth() {
        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
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

    function toggleScanning() {
        if (scanning) {
            Bluetooth.defaultAdapter.discovering = false;
            scanning = false;
        } else {
            Bluetooth.defaultAdapter.discovering = true;
            scanning = true;
        }
    }
    
}