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
            model: TaskbarApps.apps
            delegate: Item {
                id: appEntry
                required property var modelData
                required property int index
                property bool isSeparator: modelData.appId === "SEPARATOR"
                Layout.fillHeight: true
                width: isSeparator ? 1 : 40
                Loader {
                    active: !appEntry.isSeparator
                    sourceComponent: Rectangle {
                        id: appButton
                        property bool isActive: modelData.toplevels.some(t => t.activated)
                        property DesktopEntry desktopEntry: DesktopEntries.heuristicLookup(modelData.appId)
                        implicitHeight: 40
                        width: 40
                        color: isActive ? Colors.primary_container : "transparent"
                        radius: 10

                        IconImage {
                            anchors.centerIn: parent
                            source: Quickshell.iconPath(HyprlandUtil.guessIcon(modelData.appId))
                            implicitSize: 28
                            z: 5
                            anchors.verticalCenterOffset: Config.options.barPosition == 1 ? -1 : 1
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (modelData.toplevels.length > 0)
                                    modelData.toplevels[0].activate();
                                else
                                    desktopEntry.execute();
                            }
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                        }

                        RowLayout {
                            anchors.bottom: Config.options.barPosition == 1 ? parent.bottom : undefined
                            anchors.top: Config.options.barPosition == 0 ? parent.top : undefined
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: 2
                            spacing: 2

                            Repeater {
                                id: toplevelRepeater
                                model: modelData.toplevels
                                delegate: Rectangle {
                                    required property var modelData
                                    implicitWidth: this.modelData.activated ? appEntry.width * 0.4 : height
                                    implicitHeight: 4
                                    color: Colors.primary
                                    radius: 3

                                    Behavior on implicitWidth {
                                        NumberAnimation {
                                            duration: 200
                                            easing.type: Easing.OutQuint
                                        }
                                    }
                                }
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }

                Loader {
                    anchors.fill: parent
                    active: appEntry.isSeparator && appEntry.index < TaskbarApps.apps.length - 1
                    sourceComponent: Rectangle {
                        color: Qt.alpha(Colors.on_surface, 0.2)
                        implicitWidth: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 6
                    }
                }
            }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
}
