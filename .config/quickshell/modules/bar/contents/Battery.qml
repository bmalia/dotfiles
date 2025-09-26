import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets
import qs

Rectangle {
    id: container
    implicitWidth: text.width + circle.width + 20
    color: battery.state === UPowerDeviceState.Charging ? Colors.primary_container : Colors.surface_container
    radius: 999
    property UPowerDevice battery: UPower.displayDevice

    Behavior on color {
        ColorAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 5
        spacing: 0

        WavyCircularProgress {
            id: circle
            progress: battery.percentage
            diameter: 30
            thickness: 3
            color: battery.percentage > 0.2 ? Colors.primary : Colors.error
            trackColor: Colors.surface_variant
            waveAmplitude: battery.state === UPowerDeviceState.Charging ? 1 : 0
            waveCount: 9
            scrollSpeed: battery.state === UPowerDeviceState.Charging ? -0.05 : 0
            centerItem: Text {
                text: battery.state === UPowerDeviceState.Charging ? "󰂄" : "󰁹"
                color: battery.percentage > 0.2 ? Colors.on_surface : Colors.on_error
                font.pixelSize: 16
                font.bold: true
                font.family: "Roboto"
                verticalAlignment: Text.AlignVCenter
            }
        }

        Text {
            id: text
            text: Math.round(battery.percentage * 100) + "%"
            color: battery.state === UPowerDeviceState.Charging ? Colors.on_primary_container : Colors.on_surface
            font.pixelSize: 16
            font.bold: true
            font.family: Config.fontFamily
            verticalAlignment: Text.AlignVCenter
        }
    }
}
