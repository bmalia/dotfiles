import Quickshell
import Quickshell.Bluetooth
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs
import qs.modules.common
import qs.modules.widgets

Rectangle {
    id: container
    Layout.minimumWidth: Config.btShowOnEmpty ? 0 : 40
    visible: Config.btShowOnEmpty ? true : adapterState === "connected"
    implicitWidth: visible ? (content.implicitWidth + 20) : 0
    implicitHeight: visible ? (content.implicitHeight + 10) : 0
    color: Colors.surface_container
    radius: 999

    readonly property var adapterState: connectedDevices.length > 0 ? "connected" : Bluetooth.defaultAdapter.enabled ? "on" : "off"
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
        spacing: 2
        Text {
            Layout.leftMargin: 10
            text: container.adapterState === "connected" ? "󰂱" : container.adapterState === "on" ? "󰂯" : "󰂲"
            font.pixelSize: 20
            color: Colors.primary
        }
        Repeater {
            model: container.connectedDevices
            Layout.rightMargin: 10
            delegate: Rectangle {
                height: 26
                width: batteryIndicator.width
                color: modelData.batteryAvailable && modelData.battery < 0.2 ? Colors.error_container : Colors.surface_container
                radius: 999
                anchors.verticalCenter: parent.verticalCenter

                WavyCircularProgress {
                    id: batteryIndicator
                    progress: modelData.batteryAvailable ? modelData.battery : 0
                    color: modelData.batteryAvailable && modelData.battery < 0.2 ? Colors.error : Colors.secondary
                    diameter: 26
                    thickness: 2
                    scrollSpeed: modelData.state === BluetoothDeviceState.Connecting ? -0.15 : 0
                    waveAmplitude: modelData.state === BluetoothDeviceState.Connecting ? 1 : 0
                    waveCount: 8
                    centerItem: IconImage {
                        source: Quickshell.iconPath(modelData.icon)
                        width: 15
                        height: 15
                    }
                }
            }
        }
    }
}
