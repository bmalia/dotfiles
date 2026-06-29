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
    color: Appearance.colors.surface_container
    radius: 20

    property Notification notification: null


    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.notification.actions[0].invoke() // invoke the default action when the notification is clicked
        }
        onEntered: {
            root.color = Appearance.colors.surface_container_highest
        }
        onExited: {
            root.color = Appearance.colors.surface_container
        }
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        Item {
            Layout.alignment: Qt.AlignTop
            visible: root.notification.image
            Layout.preferredHeight: 55
            implicitWidth: height

            ClippingWrapperRectangle {
                anchors.fill: parent
                anchors.margins: 5
                radius: 15
                color: "transparent"

                Image {
                    anchors.fill: parent
                    source: root.notification.image
                }
            }

            ClippingWrapperRectangle {
                visible: root.notification.appIcon
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }

                implicitHeight: 24
                implicitWidth: implicitHeight
                radius: 99
                color: Appearance.colors.surface_container_highest

                Image {
                    anchors.fill: parent
                    anchors.margins: 1
                    source: Quickshell.iconPath(root.notification.appIcon)
                }
            }
        }

        ColumnLayout {

            spacing: 3
            Layout.leftMargin: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 5

                ClippingWrapperRectangle {
                    visible: root.notification.appIcon && !root.notification.image
                    implicitHeight: 18
                    implicitWidth: 18
                    radius: 99
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        source: Quickshell.iconPath(root.notification.appIcon)
                    }
                }
                Text {
                    text: root.notification.appName
                    font.family: Config.options.fontFamily
                    color: Appearance.colors.on_surface_variant
                    font.pixelSize: 14
                }
                Item {
                    Layout.fillWidth: true
                }
                Button {
                    implicitHeight: 20
                    implicitWidth: 20
                    contentItem: MaterialIcon {
                        text: "close"
                        color: Appearance.colors.on_surface_variant
                        iconSize: 13
                        weight: 600
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: Appearance.colors.surface_container_highest
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
                color: Appearance.colors.on_surface
                font.pixelSize: 16
                font.bold: true
                wrapMode: Text.Wrap
            }

            Text {
                text: root.notification.body
                visible: root.notification.body
                font.family: Config.options.fontFamily
                color: Appearance.colors.on_surface_variant
                font.pixelSize: 14
                wrapMode: Text.Wrap
                Layout.maximumWidth: parent.width - 20
            }

            Item {
                visible : root.notification.actions.length > 0
                Layout.fillWidth: true
                Layout.preferredHeight: 3
            }

            RowLayout {
                visible: root.notification.actions.length > 1
                Layout.fillWidth: true
                spacing: 5

                Repeater {
                    model: root.notification.actions.slice(1) // remove the 1st action, as it is the default action and is invoked when the notification is clicked
                    delegate: Rectangle {
                        required property var modelData
                        implicitWidth: text.implicitWidth + 10
                        implicitHeight: text.implicitHeight + 5
                        color: "transparent"

                        Text {
                            id: text
                            anchors.centerIn: parent
                            text: parent.modelData.text
                            font.family: Config.options.fontFamily
                            font.bold: true
                            font.pixelSize: 14
                            color: Appearance.colors.primary
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                parent.modelData.invoke()
                            }
                        }
                    }
                }
            }
        }
    }
}
