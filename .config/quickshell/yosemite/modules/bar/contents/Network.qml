import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.modules.common
import qs.services

Rectangle {
    radius: 999
    color: "transparent"
    implicitWidth: height

    MaterialIcon {
        text: Network.wifiStatus === "disconnected" ? "signal_wifi_bad" : Network.wifiStatus === "connecting" ? "cached" : Network.materialSymbol
        color: Network.wifiStatus === "disabled" ? Qt.alpha(Colors.on_surface, 0.5) : Colors.on_surface
        anchors.centerIn: parent
        iconSize: 23
    }
}