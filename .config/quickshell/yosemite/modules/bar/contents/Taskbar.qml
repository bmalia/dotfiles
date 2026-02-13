import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import qs.modules.common
import qs.modules.widgets
import qs.services

Rectangle {
    id: root
    Layout.fillHeight: true
    implicitWidth: content.implicitWidth
    color: Colors.surface_container
    topLeftRadius: 20
    topRightRadius: 10
    bottomLeftRadius: 20
    bottomRightRadius: 10

    RowLayout {
        id: content
        anchors.fill: parent
        spacing: 3

        Rectangle {
            Layout.fillHeight: true
            Layout.margins: 3
            implicitWidth: height
            color: Colors.primary
            radius: 20

            MaterialIcon {
                anchors.centerIn: parent
                text: "rocket_launch"
                color: Colors.on_primary
                iconSize: 24
                filled: false
                weight: 350
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(["vicinae", "toggle"])
            }
        }

        Repeater {
            id: taskbarRepeater
            model: Hyprland.toplevels
            delegate: Rectangle {
                implicitWidth: 40
                implicitHeight: 40
                color: modelData.activated ? modelData.urgents ? Colors.error_container : Colors.primary_container : "transparent"
                radius: 10

                IconImage {
                    anchors.centerIn: parent
                    source: Quickshell.iconPath(HyprlandUtil.guessIcon(modelData.wayland.appId))
                    implicitSize: 28
                    z: 5
                    anchors.verticalCenterOffset: Config.barPosition === "bottom" ? -1 : 1
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.wayland.activate()
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                }

                Rectangle {
                    anchors.bottom: Config.barPosition === "bottom" ? parent.bottom : undefined
                    anchors.top: Config.barPosition === "top" ? parent.top : undefined
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: modelData.activated ? parent.width * 0.4 : height
                    height: 4
                    anchors.margins: 2
                    radius: 20
                    color: Colors.primary

                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
            onItemAdded: {}
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
}
