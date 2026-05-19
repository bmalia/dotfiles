import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common

Rectangle {
    id: root
    width: 100
    height: content.implicitHeight + 20
    color: Colors.surface_container
    radius: 20

    property Notification notification: null

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        RowLayout {
            Layout.fillWidth: true
            spacing: 5

            ClippingWrapperRectangle {
                visible: root.notification.appIcon !== ""
                implicitHeight: 16
                implicitWidth: 16
                radius: 99
                IconImage {
                    anchors.fill: parent
                    source: root.notification.appIcon
                }
            }
            Text {
                text: root.notification.appName
                font.family: "Roboto"
                color: Colors.on_surface_variant
                font.pixelSize: 14
            }
            Item {
                Layout.fillWidth: true
            }
            Button {
                implicitHeight: 16
                implicitWidth: 16
                contentItem: MaterialIcon {
                    text: "close"
                    color: Colors.on_surface_variant
                    iconSize: 13
                    weight: 600
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: Colors.surface_container_highest
                    radius: 99
                }
                onClicked: {
                    root.notification.dismiss();
                }
            }
        }
        Text {
            text: root.notification.summary
            font.family: Config.options.fontFamily
            color: Colors.on_surface
            font.pixelSize: 16
            font.bold: true
            wrapMode: Text.Wrap
        }
    }
}
