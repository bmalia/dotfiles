import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.UPower
import qs.modules.common
import qs.modules.widgets.shapes
import qs.modules.widgets
import qs.services
import "../../widgets/shapes/material-shapes.js" as MaterialShapes

RowLayout {
    property UPowerDevice battery: UPower.displayDevice
    id: root
    anchors {
        left: parent.left
        top: parent.top
        bottom: parent.bottom
        leftMargin: 0
    }
    spacing: 2

    ClippingRectangle {
        id: batteryIndicator
        implicitWidth: 30
        implicitHeight: 15
        radius: 5
        color: Qt.alpha(Appearance.colors.on_surface, 0.5)

        Rectangle {
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: root.battery.percentage * batteryIndicator.width
            color: root.battery.state === UPowerDeviceState.Charging ? "green" : PowerProfiles.profile === PowerProfile.PowerSaver ? "orange" : Appearance.colors.on_surface
        }

        RowLayout {
            spacing: 0
            anchors.centerIn: parent
            MaterialIcon {
                visible: root.battery.state === UPowerDeviceState.Charging || PowerProfiles.profile === PowerProfile.PowerSaver
                text: root.battery.state === UPowerDeviceState.Charging ? "bolt" : "add_2"
                iconSize: 10
                filled: true
                weight: 800
                Layout.bottomMargin: 1.25
            }

            Text {
                text: Math.round(root.battery.percentage * 100)
                font.pixelSize: 13
                color: Appearance.colors.surface
                font.bold: true
            }
        }
    }

    Rectangle {
        id: batteryCap
        width: 1.5
        height: 7
        color: Qt.alpha(Appearance.colors.on_surface, 0.5)
        topRightRadius: 99
        bottomRightRadius: 99
    }
}
