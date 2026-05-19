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
    height: 70
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
                bottomRightRadius: 99
                implicitWidth: leftContent.implicitWidth + 10
                color: Appearance.colors.background
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
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
                    anchors.leftMargin: 0
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

            RoundCorner {
                id: leftRound
                anchors {
                    top: parent.top
                    left: leftBg.right
                }
                color: Appearance.colors.background
                implicitSize: 15
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
                bottomLeftRadius: 99
                implicitWidth: rightContent.implicitWidth + 15
                color: Appearance.colors.background
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
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

                    Loader {
                        sourceComponent: System {}
                        Layout.fillHeight: true
                    }
                }
            }

            RoundCorner {
                anchors {
                    top: parent.top
                    right: rightBg.left
                }
                color: Appearance.colors.background
                implicitSize: 15
                corner: RoundCorner.CornerEnum.TopRight
            }
        }
    }
}
