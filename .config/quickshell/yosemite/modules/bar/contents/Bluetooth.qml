import Quickshell
import Quickshell.Bluetooth
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets
import qs.services

Rectangle {
    id: container
    anchors.fill: parent
    Layout.minimumWidth: Config.options.btShowOnEmpty ? 0 : 40
    visible: Config.options.btShowOnEmpty ? true : BtService.btStatus === "connected"
    implicitWidth: visible ? (content.implicitWidth + 10) : 0
    // implicitHeight: visible ? (content.implicitHeight + 10) : 0
    color: BtService.btStatus === "connected" ? Colors.secondary_container : "transparent"
    radius: 99

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 500
            easing.type: Easing.InOutBack
        }
    }

    RowLayout {
        id: content
        anchors.fill: parent
        spacing: 1
        MaterialIcon {
            Layout.leftMargin: 5
            text: BtService.materialSymbol
            iconSize: 23
            color: BtService.btStatus === "connected" ? Colors.secondary : BtService.btStatus === "on" ? Colors.on_surface : Qt.alpha(Colors.on_surface, 0.5)
        }
        Repeater {
            model: BtService.connectedDevices
            Layout.rightMargin: 5
            delegate: Rectangle {
                id: deviceContainer
                required property BluetoothDevice modelData
                height: 26
                width: batteryIndicator.width
                color: "transparent"
                radius: 999

                WavyCircularProgress {
                    id: batteryIndicator
                    progress: deviceContainer.modelData.batteryAvailable ? deviceContainer.modelData.battery : 0
                    color: deviceContainer.modelData.batteryAvailable && deviceContainer.modelData.battery < 0.2 ? Colors.error : Colors.secondary
                    trackColor: Qt.alpha(Colors.on_secondary_container, 0.3)
                    diameter: 26
                    thickness: 2.5
                    scrollSpeed: deviceContainer.modelData.state === BluetoothDeviceState.Connecting ? -0.15 : 0
                    waveAmplitude: deviceContainer.modelData.state === BluetoothDeviceState.Connecting ? 1 : 0
                    waveCount: 8
                    centerItem: MaterialIcon {
                        text: BtService.fetchDeviceIcon(deviceContainer.modelData.icon)
                        color: Colors.on_secondary_container
                        iconSize: 15
                        weight: 500
                        filled: true
                    }
                }
            }
        }
    }
}
