import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.UPower
import qs.modules.common
import qs.modules.widgets.shapes
import qs.modules.widgets
import qs.services
import "../../widgets/shapes/material-shapes.js" as MaterialShapes

Item {
    id: root
    property UPowerDevice battery: UPower.displayDevice
    implicitWidth: content.implicitWidth

    RowLayout {
        id: content
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
            color: Qt.alpha(Appearance.colors.on_surface, 0.4)

            Rectangle {
                id: batteryLevel
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: root.battery.percentage * batteryIndicator.width
                color: root.battery.state === UPowerDeviceState.Charging ? "#51A848" : PowerProfiles.profile === PowerProfile.PowerSaver ? "#E39224" : Appearance.colors.on_surface
            }

            RowLayout {
                spacing: 0
                anchors.centerIn: parent
                property UPowerDevice battery: UPower.displayDevice
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
            color: root.battery.percentage < 0.95 ? Qt.alpha(Appearance.colors.on_surface, 0.3) : batteryLevel.color
            topRightRadius: 99
            bottomRightRadius: 99
        }
    }

    MaterialIcon {
        z: 4
        id: statusIcon
        visible: (root.battery.state === UPowerDeviceState.Charging)
        x: batteryCap.x - batteryCap.width * 2 - 4
        y: batteryCap.y + (batteryCap.height - implicitHeight) / 2
        color: Appearance.colors.on_surface
        text: "bolt"
        iconSize: 14
        filled: true
    }

    MaterialIcon {
        z: 3
        id: statusIconBg
        visible: statusIcon.visible
        anchors {
            centerIn: statusIcon
            verticalCenterOffset: 1
            horizontalCenterOffset: -0.8
        }
        color: Appearance.colors.background
        text: statusIcon.text
        iconSize: 22
        filled: true
    }
}