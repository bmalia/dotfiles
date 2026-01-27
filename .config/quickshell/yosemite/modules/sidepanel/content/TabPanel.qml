//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common
import qs.modules.widgets
import qs.services

Rectangle {
    id: root
    width: parent.width
    height: content.implicitHeight + 20
    color: Colors.surface_container_lowest
    radius: 20

    ColumnLayout {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        spacing: 10

        ConnectedButtonGroup {
            id: toggleGroup
            Layout.alignment: Qt.AlignHCenter
            anchors.topMargin: 20
            buttonAmount: 3
            selectedIndex: 0
            buttonLabels: ["Notifications", "Wi-Fi", "Bluetooth"]
            buttonIcons: ["notifications", "wifi", "bluetooth"]
        }

        StackLayout {
            Layout.fillWidth: true
            currentIndex: toggleGroup.selectedIndex

            Rectangle { // Notifications Panel
                color: Colors.surface_container_low
                radius: 20

                Text {
                    anchors.centerIn: parent
                    text: "Notification service not active: disabled in configuration"
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    width: parent.width - 40
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 14
                    color: Colors.on_surface_variant
                }
            }

            Loader {
                id: wifiPanelLoader
                sourceComponent: WifiMenu {}
            }

            Loader {
                id: bluetoothPanelLoader
                sourceComponent: BluetoothMenu {}
            }
        }
    }
}
