import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common
import qs.modules.widgets
import qs.services

Rectangle {
    color: Colors.surface_container_low
    height: 700
    radius: 20

    Text {
        visible: BtService.btStatus === "off"
        anchors.centerIn: parent
        text: "Bluetooth is disabled"
        color: Colors.on_surface_variant
        font.pixelSize: 14
        font.family: Config.options.fontFamily
    }

    ColumnLayout {
        visible: BtService.btStatus !== "off"
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        Text {
            visible: BtService.connectedDevices.length > 0
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            text: "Connected Devices"
            font.pixelSize: 16
            font.family: Config.options.fontFamily
            color: Colors.on_surface_variant
            font.bold: true
        }

        Repeater {
            model: BtService.connectedDevices
            delegate: BluetoothMenuEntry {
                Layout.fillWidth: true
                required property int index
                required property BluetoothDevice modelData
                device: modelData
                topRadius: index === 0 ? 20 : 5
                bottomRadius: index === BtService.connectedDevices.length - 1 ? 20 : 5
            }
        }

        RowLayout {
            id: headerRow
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            Layout.fillWidth: true

            Text {
                text: "Available Devices"
                font.pixelSize: 16
                font.bold: true
                color: Colors.on_surface_variant
                font.family: Config.options.fontFamily
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                id: scanToggle
                width: 50
                height: 20
                Layout.alignment: Qt.AlignRight
                contentItem: MaterialIcon {
                    text: BtService.scanning ? "nearby" : "nearby_off"
                    color: BtService.scanning ? Colors.on_primary_container : Colors.on_surface_variant
                    font.pixelSize: 20
                }
                background: Rectangle {
                    width: 30
                    color: BtService.scanning ? Colors.primary_container : Colors.surface_container_high
                    radius: 999
                }
                onClicked: {
                    BtService.toggleScanning();
                }
            }
        }

        Flickable {
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            contentHeight: devicesList.height
            contentWidth: devicesList.width

            ColumnLayout {
                id: devicesList
                width: parent.width
                spacing: 5

                Repeater {
                    model: BtService.devices ? BtService.devices.values.filter(d => d.state === BluetoothDeviceState.Disconnected || d.state === BluetoothDeviceState.Disconnecting) : []
                    delegate: BluetoothMenuEntry {
                        width: headerRow.width
                        required property int index
                        required property BluetoothDevice modelData
                        device: modelData
                        topRadius: index === 0 ? 20 : 5
                        bottomRadius: index === BtService.devices.values.filter(d => d.state === BluetoothDeviceState.Disconnected || d.state === BluetoothDeviceState.Disconnecting).length - 1 ? 20 : 5
                    }
                }
            }
        }
    }
}
