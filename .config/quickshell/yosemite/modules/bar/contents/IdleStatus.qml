import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services

Rectangle {
    visible: IdleInhibitor.inhibit
    color: "transparent"
    implicitWidth: IdleInhibitor.inhibit ? height : 0

    MaterialIcon {
        visible: IdleInhibitor.inhibit
        text: "coffee"
        color: Colors.on_surface
        anchors.centerIn: parent
        iconSize: 23
        filled: true
    }
}