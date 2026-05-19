import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services.network
import qs.services

Rectangle {
    id: root
    required property WifiAccessPoint wifi
    property bool hovered: false
    property bool connecting: false
    property int topRadius: 20
    property int bottomRadius: 20

    height: 60
    color: root.hovered ? Colors.tertiary_container : (root.wifi.active ? Colors.secondary_container : Colors.surface_container_high)
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
        anchors.fill: parent
        anchors.margins: 10
        MaterialIcon {
            id: icon
            text: root.getIcon()
            iconSize: 32
            color: root.wifi.active ? Colors.on_secondary_container : Colors.on_surface_variant
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 5
            spacing: 2

            Text {
                text: wifi.ssid
                font.pixelSize: 16
                font.bold: true
                color: root.wifi.active ? Colors.on_secondary_container : Colors.on_surface
                font.family: Config.options.fontFamily
                elide: Text.ElideRight
                Layout.maximumWidth: root.width - icon.width - 80
            }

            Text {
                visible: wifi.active || root.connecting
                text: wifi.active ? "Connected" : "Connecting..."
                font.pixelSize: 12
                color: root.wifi.active ? Colors.on_secondary_container : Colors.on_surface_variant
                font.family: Config.options.fontFamily
            }
        }

        Item {
            Layout.fillWidth: true
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: true
            layoutDirection: Qt.RightToLeft

            Text {
                text: wifi.isSecure ? wifi.security : "Open"
                font.pixelSize: 12
                color: root.wifi.active ? Colors.on_secondary_container : Colors.on_surface_variant
                font.family: Config.options.fontFamily
                horizontalAlignment: Text.AlignRight
            }

            Text {
                text: (wifi.frequency * 0.001).toFixed(1) + " GHz"
                font.pixelSize: 12
                color: root.wifi.active ? Colors.on_secondary_container : Colors.on_surface_variant
                font.family: Config.options.fontFamily
                horizontalAlignment: Text.AlignRight
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (!root.wifi.active) {
                Network.connectToWifiNetwork(root.wifi);
                root.connecting = true;
            }
        }
        onEntered: {
            root.hovered = true;
        }
        onExited: {
            root.hovered = false;
        }
    }

    function getIcon() {
        if (wifi.strength > 83)
            return "signal_wifi_4_bar";
        if (wifi.strength > 67)
            return "network_wifi";
        if (wifi.strength > 50)
            return "network_wifi_3_bar";
        if (wifi.strength > 33)
            return "network_wifi_2_bar";
        if (wifi.strength > 17)
            return "network_wifi_1_bar";
        return "signal_wifi_0_bar";
    }
}
