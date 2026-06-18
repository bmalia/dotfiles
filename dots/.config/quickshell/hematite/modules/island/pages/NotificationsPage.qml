import QtQuick
import qs.modules.common

QtObject {
    id: root

    property string pageId: "notifications"
    property string title: "Notifications"
    property string materialIcon: "notifications"
    property int priority: 30
    property bool hasCollapsedContent: true
    property bool isActive: false
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
            implicitWidth: content.implicitWidth
            implicitHeight: content.implicitHeight

            Row {
                id: content
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 6

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 18
                    height: 18
                    radius: 9
                    color: Qt.alpha(Appearance.colors.tertiary, 0.2)

                    Text {
                        anchors.centerIn: parent
                        text: "notifications"
                        color: Appearance.colors.tertiary
                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 12
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(20, parent.width - 30)
                    text: "Alerts"
                    color: Appearance.colors.on_surface
                    font.family: Config.options.fontFamily
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideRight
                }
            }
        }
    }

    property Component expandedComponent: Component {
        Item {
            Text {
                anchors.centerIn: parent
                text: "WIP"
                color: Qt.alpha(Appearance.colors.on_surface, 0.4)
                font.family: Config.options.fontFamily
                font.pixelSize: 50
                font.bold: true
            }
        }
    }
}
