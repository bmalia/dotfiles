import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.modules.common
import qs.services

Rectangle {
    radius: 999
    color: Colors.surface_container
    implicitWidth: height

    MaterialIcon {
        text: Network.materialSymbol
        color: Colors.on_surface
        anchors.centerIn: parent
        iconSize: 23
    }
}