import QtQuick
import Quickshell.Services.SystemTray
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets

Rectangle {
    implicitWidth: layout.implicitWidth + 20
    color: Appearance.colors.surface
    radius: 10

    RowLayout {
        id: layout
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8

        Repeater {
            model: SystemTray.items
            delegate: SysTrayItem {
                required property SystemTrayItem modelData
                item: modelData
            }
        }
    }
}