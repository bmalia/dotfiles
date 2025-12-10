import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets
import qs

Rectangle {
    property UPowerDevice battery: UPower.displayDevice
    id: container
    implicitWidth: text.width + circle.width + 20
    property color criticalBgColor: Config.batteryUseErrorContainer ? Colors.error_container : Colors.error
    property color criticalFgColor: Config.batteryUseErrorContainer ? Colors.error : Colors.on_error
    color: battery.state === UPowerDeviceState.Charging ? Colors.primary_container : battery.percentage > Config.batteryLowThreshold ? Colors.surface_container : criticalBgColor
    radius: 999
    

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
            color: battery.percentage > Config.batteryLowThreshold ? Colors.primary : criticalFgColor
            trackColor: battery.percentage > Config.batteryLowThreshold ? Colors.secondary_container : criticalBgColor
            waveAmplitude: battery.state === UPowerDeviceState.Charging ? 1 : 0
            waveCount: 9
            scrollSpeed: battery.state === UPowerDeviceState.Charging ? -0.05 : 0
            centerItem: Text {
                text: getBatteryIcon(battery.percentage, battery.state === UPowerDeviceState.Charging)
                color: battery.percentage > Config.batteryLowThreshold ? Colors.on_surface : criticalFgColor
                font.pixelSize: 16
                font.bold: true
                font.family: "JetBrainsMono NF"
                verticalAlignment: Text.AlignVCenter
            }
        }

        Text {
            id: text
            text: Math.round(battery.percentage * 100) + "%"
            color: battery.state === UPowerDeviceState.Charging ? Colors.on_primary_container : battery.percentage > Config.batteryLowThreshold ? Colors.on_surface : criticalFgColor
            font.pixelSize: 16
            font.bold: true
            font.family: Config.fontFamily
            verticalAlignment: Text.AlignVCenter
        }
    }

    function getBatteryIcon(percentage, isCharging) {
        if (isCharging)
            return "󰂄";  // Charging icon

        if (percentage > 0.95)
            return "󰁹";      // 96-100%
        if (percentage > 0.9)
            return "󰂂";       // 91-95%
        if (percentage > 0.8)
            return "󰂁";       // 81-90%
        if (percentage > 0.7)
            return "󰂀";       // 71-80%
        if (percentage > 0.6)
            return "󰁿";       // 61-70%
        if (percentage > 0.5)
            return "󰁾";       // 51-60%
        if (percentage > 0.4)
            return "󰁽";       // 41-50%
        if (percentage > 0.3)
            return "󰁼";       // 31-40%
        if (percentage > 0.2)
            return "󰁻";       // 21-30%
        if (percentage > 0.1)
            return "󰁺";       // 11-20%
        return "󰂎";           // 0-10%
    }
}
