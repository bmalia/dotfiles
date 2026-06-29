import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets
import qs.services

QtObject {
    id: root

    property string pageId: "notifications"
    property string title: "Notifications"
    property string materialIcon: "notifications"
    property int priority: 60
    property bool hasCollapsedContent: true
    property bool isActive: Notifications.numNotifications > 0
    property int collapsedWidth: 0
    property int sidePillWidth: 0

    property Component collapsedComponent: Component {
        Item {
            id: rootItem
            implicitWidth: content.implicitWidth
            implicitHeight: content.implicitHeight

            Row {
                id: content
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 8

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 20
                    height: 20
                    radius: 10
                    color: Qt.alpha(Appearance.colors.tertiary, 0.2)

                    Text {
                        anchors.centerIn: parent
                        text: "notifications"
                        color: Appearance.colors.tertiary
                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 14
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(40, parent.width - 28)
                    text: "Notifications"
                    color: Appearance.colors.on_surface
                    font.family: Config.options.fontFamily
                    font.pixelSize: 13
                    font.bold: true
                    elide: Text.ElideRight
                }
            }
        }
    }

    property Component sidePillComponent: Component {
        Item {
            id: rootItem
            implicitWidth: content.implicitWidth + 16
            implicitHeight: content.implicitHeight

            RowLayout {
                id: content
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: 7
                }
                spacing: 2

                MaterialIcon {
                    text: "notifications"
                    color: Appearance.colors.on_surface
                    font.pixelSize: 20
                }

                MaterialShape {
                    Layout.fillHeight: true
                    Layout.topMargin: 1
                    Layout.bottomMargin: 1
                    implicitWidth: height
                    shape: MaterialShape.Cookie9Sided
                    color: Appearance.colors.primary

                    Text {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 1 // Canvas is a great type with no issues whatsoever
                        text: Notifications.numNotifications
                        color: Appearance.colors.on_primary
                        font.family: Config.options.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                    }
                }
            }
        }
    }

    property Component expandedComponent: Component {
        Item {
            Flickable {
                visible: Notifications.numNotifications > 0
                anchors {
                    fill: parent
                    margins: 10
                    leftMargin: 100
                    rightMargin: 100
                }
                clip: true

                contentWidth: content.width
                contentHeight: content.height
                ColumnLayout {
                    id: content
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: 1
                    }
                    spacing: 10

                    Repeater {
                        model: Notifications.server.trackedNotifications.values
                        Layout.fillWidth: true
                        delegate: Notification {
                            required property var modelData
                            notification: modelData
                            implicitWidth: parent.width
                        }
                    }
                }
            }

            Item {
                visible: Notifications.numNotifications === 0
                anchors.fill: parent

                Column {
                    spacing: 10
                    anchors.centerIn: parent
                    MaterialIcon {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "notifications"
                        color: Appearance.colors.on_surface_variant
                        font.pixelSize: 48
                        filled: true
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "No notifications"
                        color: Appearance.colors.on_surface
                        font.family: Config.options.fontFamily
                        font.pixelSize: 16
                    }
                }
            }
        }
    }
}
