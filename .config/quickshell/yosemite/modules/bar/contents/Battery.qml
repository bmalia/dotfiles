import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.UPower
import qs.modules.common
import qs.modules.widgets.shapes
import qs.modules.widgets
import qs.services
import "../../widgets/shapes/material-shapes.js" as MaterialShapes

ClippingRectangle {
    id: root
    implicitWidth: content.implicitWidth + widthOffset
    color: Appearance.colors.surface
    radius: 20

    border.width: 1
    border.color: Qt.alpha(Appearance.colors.on_surface, 0.12)

    property UPowerDevice battery: UPower.displayDevice
    property bool hovered: false

    property real waveAmplitude: battery.state === UPowerDeviceState.Charging ? 1 : 0
    property real scrollSpeed: battery.state === UPowerDeviceState.Charging ? 0.03 : 0
    property int widthOffset: 15

    RowLayout {
        spacing: 5
        id: content
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: batteryContainer
            height: 40
            width: 30
            
            WavyCircularProgress {
                id: batteryProgress
                anchors.centerIn: parent
                width: 30
                height: 30
                progress: root.battery.percentage
                thickness: 4
                progressGap: 0.4
                waveAmplitude: root.waveAmplitude
                waveCount: 7
                scrollSpeed: root.scrollSpeed

                centerItem: MaterialIcon {
                    text: "bolt"
                    filled: root.battery.state === UPowerDeviceState.Charging
                    font.pixelSize: 18
                    color: root.battery.state === UPowerDeviceState.Charging ? Appearance.colors.primary : Appearance.colors.on_surface_variant
                }
            }
        }
        
        Text {
            id: percentageText
            color: Appearance.colors.on_surface
            font.pixelSize: 16
            font.bold: true
            font.family: Config.options.fontFamily
            text: Math.round(root.battery.percentage * 100) + "%"
            Layout.alignment: Qt.AlignVCenter

            Behavior on font.pixelSize {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                }
            }
        }

        Text {
            id: timeText
            color: Appearance.colors.on_surface_variant
            width: root.hovered ? implicitWidth : 0
            opacity: root.hovered ? 1 : 0
            visible: root.hovered
            font.pixelSize: 13
            font.family: Config.options.fontFamily
            text: {
                if (root.battery.state !== UPowerDeviceState.Charging) {
                    if (root.battery.timeToEmpty === 0) {
                        return "Estimating time remaining...";
                    }
                    const totalSeconds = Math.max(0, Math.floor(root.battery.timeToEmpty || 0));
                    const hours = Math.floor(totalSeconds / 3600);
                    const minutes = Math.floor((totalSeconds % 3600) / 60);

                    if (hours > 0) {
                        return hours + "h " + minutes + "m left";
                    }
                    return minutes + "m left";
                }

                if (root.battery.timeToFull === 0) {
                    return "Estimating time remaining...";
                }
                const totalSeconds = Math.max(0, Math.floor(root.battery.timeToFull || 0));
                const hours = Math.floor(totalSeconds / 3600);
                const minutes = Math.floor((totalSeconds % 3600) / 60);

                if (hours > 0) {
                    return hours + "h " + minutes + "m until full";
                }
                return minutes + "m until full";
            }
            Behavior on width {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.easings.expressiveDefaultEffects
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
    }

    Timer {
        id: splashTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            batteryProgress.waveAmplitude = root.waveAmplitude;
            batteryProgress.scrollSpeed = root.scrollSpeed;
            batteryProgress.trackColor = Appearance.colors.secondary_container;
            root.color = Appearance.colors.surface;
            root.widthOffset = 15;
            percentageText.font.pixelSize = 16
        }
    }

    Connections {
        target: root.battery
        function onStateChanged() {
            batteryProgress.waveAmplitude = root.battery.state === UPowerDeviceState.Charging ? 1.5 : 0;
            batteryProgress.scrollSpeed = root.battery.state === UPowerDeviceState.Charging ? 0.05 : 0;
            batteryProgress.trackColor = Appearance.colors.primary_container;
            root.color = Appearance.colors.primary_container;
            root.widthOffset = 45
            percentageText.font.pixelSize = 23
            CookieButtonState.setTransientShape(MaterialShapes.getBoom(), 0, 1500);
            splashTimer.restart();
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 500
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.easings.expressiveDefaultEffects
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 500
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
        }
    }
}