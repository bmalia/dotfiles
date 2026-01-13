pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Bluetooth

Singleton {
    id: bluetoothService
    
    property string btStatus: connectedDevices.length > 0 ? "connected" : Bluetooth.defaultAdapter.enabled ? "on" : "off"
    // Apparently Bluetooth.devices is actually a list of all devices the adapter can see, not just paired ones
    property var connectedDevices: Bluetooth.devices ? Bluetooth.devices.values.filter(d => d.state === BluetoothDeviceState.Connected || d.state === BluetoothDeviceState.Connecting) : []

    property string materialSymbol: btStatus === "connected" ? "bluetooth_connected" : btStatus === "on" ? "bluetooth" : "bluetooth_disabled"

    property BluetoothDevice exposedDevice: connectedDevices.length > 0 ? connectedDevices[0] : null

    function toggleBluetooth() {
        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
    }
    
}