import QtQuick
import Quickshell
import qs.modules.widgets
import Quickshell.Hyprland
import QtQuick.Layouts
import qs.modules.bar.contents
import qs.modules.common
import Quickshell.Services.SystemTray

Rectangle {
    id: root
    width: 50
    color: "transparent"
    clip: true
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    readonly property var barMask: barMaskRegion

    Region {
        id: barMaskRegion
        item: leftBg

        Region {
            item: rightBg
        }
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        spacing: 5

        Item {
            id: leftSection
            Layout.fillHeight: true
            implicitWidth: leftBg.implicitWidth + leftRound.implicitWidth

            Rectangle {
                id: leftBg
                property bool hovered: false
                radius: 99
                implicitWidth: leftContent.implicitWidth + 10
                color: Qt.alpha(Appearance.colors.background, Appearance.surfaceOpacity1)
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin: 8
                    topMargin: !Config.options.bar.bottom ? 8 : 0
                    bottomMargin: Config.options.bar.bottom ? 8 : 0
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                    }
                }

                RowLayout {
                    id: leftContent
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.leftMargin: 5
                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                    spacing: 0

                    Loader {
                        sourceComponent: CookieButton {}
                        Layout.fillHeight: true
                    }

                    Loader {
                        sourceComponent: Workspaces {}
                        Layout.fillHeight: true
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Item {
            id: rightSection
            Layout.fillHeight: true
            implicitWidth: rightBg.implicitWidth

            Rectangle {
                id: rightBg
                property bool hovered: false
                radius: 99
                implicitWidth: rightContent.implicitWidth + 15
                color: Qt.alpha(Appearance.colors.background, Appearance.surfaceOpacity1)
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: 8
                    topMargin: !Config.options.bar.bottom ? 8 : 0
                    bottomMargin: Config.options.bar.bottom ? 8 : 0
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                    }
                }

                RowLayout {
                    id: rightContent
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.rightMargin: 0
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    spacing: 10

                    AnimatedLoader {
                        shouldShow: SystemTray.items.values.length > 0
                        sourceComponent: SysTray {}
                    }

                    Rectangle {
                        radius: 10
                        implicitWidth: 5
                        implicitHeight: width
                        color: Qt.alpha(Appearance.colors.on_surface, 0.2)
                        visible: SystemTray.items.values.length > 0
                    }

                    Loader {
                        sourceComponent: System {}
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
