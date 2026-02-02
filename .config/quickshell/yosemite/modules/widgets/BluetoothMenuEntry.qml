import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common
import qs.services

Rectangle {
    id: root
    required property BluetoothDevice device
    property bool hovered: false
    property int topRadius: 20
    property int bottomRadius: 20

    height: 65
    color: root.hovered ? Colors.tertiary_container : device.connected ? Colors.secondary_container : Colors.surface_container_high
    topLeftRadius: topRadius
    topRightRadius: topRadius
    bottomLeftRadius: bottomRadius
    bottomRightRadius: bottomRadius

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }

    RowLayout {
        id: content
        z: 2
        anchors.fill: parent
        anchors.margins: 5

        WavyCircularProgress {
            id: batteryIndicator
            progress: root.device.batteryAvailable ? root.device.battery : 0
            color: root.device.batteryAvailable && root.device.battery < 0.2 ? Colors.error : root.device.connected ? Colors.secondary : Colors.on_surface_variant
            trackColor: Colors.secondary_container
            diameter: 40
            thickness: 4
            scrollSpeed: root.device.connected ? -0.04 : 0
            waveAmplitude: root.device.connected ? 1.25 : 0
            waveCount: 8
            centerItem: MaterialIcon {
                id: icon
                text: BtService.fetchDeviceIcon(root.device.icon)
                iconSize: 24
                color: root.device.connected ? Colors.on_secondary_container : Colors.on_surface_variant
                weight: 500
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.margins: 0
            spacing: 0

            Text {
                text: root.device.name
                color: root.device.connected ? Colors.on_secondary_container : Colors.on_surface
                font.pixelSize: 16
                font.family: Config.fontFamily
                font.bold: true
                elide: Text.ElideRight
                Layout.maximumWidth: root.width - batteryIndicator.width - 110
            }

            Text {
                visible: device.connected
                text: root.device.connected ? "Connected" : "Not connected"
                color: root.device.connected ? Colors.on_secondary_container : Colors.on_surface_variant
                font.pixelSize: 12
                font.family: Config.fontFamily
                elide: Text.ElideRight
            }

            Text {
                visible: root.device.bonded && !root.device.connected
                text: "Saved"
                color: root.device.connected ? Colors.on_secondary_container : Colors.on_surface_variant
                font.pixelSize: 10
                font.family: Config.fontFamily
                elide: Text.ElideRight
            }
        }

        Item {
            Layout.fillWidth: true
        }

        ColumnLayout {
            spacing: 5
            layoutDirection: Qt.RightToLeft
            Layout.maximumWidth: root.width / 4

            Button {
                z: 10
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentItem: Text {
                    text: root.device.connected ? "Disconnect" : "Connect"
                    color: root.device.connected ? Colors.on_primary : Colors.on_primary_container
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                    font.family: Config.fontFamily
                    font.bold: true
                }
                background: Rectangle {
                    color: root.device.connected ? Colors.primary : Colors.primary_container
                    radius: 20
                }

                onClicked: {
                    if (root.device.connected) {
                        root.device.disconnect();
                    } else {
                        root.device.connect();
                    }
                }

                Behavior on height {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutBounce
                    }
                }
            }

            Button {
                z: 10
                visible: root.device.bonded && !root.device.connected
                Layout.fillWidth: true
                contentItem: Text {
                    text: "Forget"
                    color: root.device.connected ? Colors.on_error : Colors.on_error_container
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 12
                    font.family: Config.fontFamily
                    font.bold: true
                }
                background: Rectangle {
                    color: root.device.connected ? Colors.error : Colors.error_container
                    radius: 10
                }

                onClicked: {
                    root.device.forget();
                }
            }
        }
    }
}
