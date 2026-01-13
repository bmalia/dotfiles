import Quickshell
import Quickshell.Bluetooth
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets
import qs.services

Rectangle {
    anchors.fill: parent
    id: container
    Layout.minimumWidth: Config.btShowOnEmpty ? 0 : 40
    visible: Config.btShowOnEmpty ? true : BtService.btStatus === "connected"
    implicitWidth: visible ? (content.implicitWidth + (BtService.btStatus === "connected" ? 10 : 10)) : 0
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
                height: 26
                width: batteryIndicator.width
                color: "transparent"
                radius: 999

                WavyCircularProgress {
                    id: batteryIndicator
                    progress: modelData.batteryAvailable ? modelData.battery : 0
                    color: modelData.batteryAvailable && modelData.battery < 0.2 ? Colors.error : Colors.secondary
                    trackColor: Qt.alpha(Colors.on_secondary_container, 0.3)
                    diameter: 26
                    thickness: 2.5
                    scrollSpeed: modelData.state === BluetoothDeviceState.Connecting ? -0.15 : 0
                    waveAmplitude: modelData.state === BluetoothDeviceState.Connecting ? 1 : 0
                    waveCount: 8
                    centerItem: MaterialIcon {
                        text: container.fetchDeviceIcon(modelData.icon)
                        color: Colors.on_primary_container
                        iconSize: 15
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
