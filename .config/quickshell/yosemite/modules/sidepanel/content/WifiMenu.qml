import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common
import qs.modules.widgets
import qs.services

Rectangle {
    color: Colors.surface_container_low
    height: 700
    radius: 20

    Text {
        visible: !Network.wifiEnabled
        anchors.centerIn: parent
        text: "Wi-Fi is disabled"
        color: Colors.on_surface_variant
        font.pixelSize: 14
        font.family: Config.fontFamily
    }

    ColumnLayout {
        visible: Network.wifiEnabled
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        WifiMenuEntry {
            id: activeWifiEntry
            visible: Network.active !== null
            wifi: Network.active
            Layout.fillWidth: true
        }

        RowLayout {
            id: headerRow
            Layout.fillWidth: true

            Text {
                text: "Available Networks"
                font.pixelSize: 16
                font.bold: true
                color: Colors.on_surface_variant
                font.family: Config.fontFamily
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                id: refreshButton
                width: 50
                height: width
                Layout.alignment: Qt.AlignRight
                contentItem: MaterialIcon {
                    text: "refresh"
                    color: Colors.on_surface_variant
                    font.pixelSize: 20
                }
                background: Rectangle {
                    width: 30
                    color: refreshButton.down ? Colors.primary_container : Colors.surface_container_highest
                    radius: 999
                }
                onClicked: {
                    Network.rescanWifi();
                }
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentHeight: accessPointList.height
            contentWidth: accessPointList.width

            ColumnLayout {
                id: accessPointList
                width: parent.contentWidth
                spacing: 5

                Repeater {
                    model: Network.friendlyWifiNetworks.filter(n => !n.active) // Sort by strength and exclude active
                    WifiMenuEntry {
                        required property int index
                        wifi: Network.friendlyWifiNetworks.filter(n => !n.active)[index]
                        width: headerRow.width
                        topRadius: index === 0 ? 20 : 5
                        bottomRadius: index === Network.friendlyWifiNetworks.filter(n => !n.active).length - 1 ? 20 : 5
                    }
                }
            }
        }

        Button {
            Layout.fillWidth: true

            contentItem: Text {
                text: "Open Connection Editor"
                font.pixelSize: 14
                font.bold: true
                color: Colors.on_primary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: Config.fontFamily
            }

            background: Rectangle {
                implicitHeight: 40
                color: Colors.primary
                radius: 999
            }

            onClicked: {
                Quickshell.execDetached(["nm-connection-editor"]);
            }
        }
    }
}
