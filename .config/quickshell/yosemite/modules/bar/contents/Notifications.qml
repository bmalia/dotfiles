import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.services

Rectangle {
    id: container
    Layout.fillHeight: true
    radius: 999
    color: "transparent"
    width: content.implicitWidth + 10

    RowLayout {
        id: content
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        MaterialIcon {
            text: "notifications"
            filled: false
            iconSize: 23
            color: Colors.on_surface
        }

        Text {
            text: Notifications.trackedNotifications.values.length.toString()
            color: Colors.on_surface
            font.pixelSize: 18
            font.family: Config.fontFamily
            font.bold: true
        }

    }

}