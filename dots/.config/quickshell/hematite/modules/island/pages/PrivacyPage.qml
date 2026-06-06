pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services

QtObject {
    id: root

    property string pageId: "privacy"
    property string title: "Privacy"
    property int priority: 30
    property bool hasCollapsedContent: true
    property bool isActive: Privacy.screenSharing || Privacy.micActive
    property int collapsedWidth: 0
    property int sidePillWidth: 0

    property string statusLabel: {
        if (Privacy.screenSharing && Privacy.micActive) return "Screen + Mic active"
        if (Privacy.screenSharing) return "Screen sharing"
        if (Privacy.micActive) return "Microphone active"
        return "No active capture"
    }

    property Component collapsedComponent: Component {
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
                    topMargin: 6
                    bottomMargin: 6
                }
                spacing: 5

                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: Privacy.screenSharing ? 40 : 60
                    color: Appearance.colors.tertiary
                    radius: 120
                    visible: Privacy.micActive

                    SequentialAnimation on opacity {
                        running: parent.visible
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.5; duration: 2000; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                    }

                    MaterialIcon {
                        anchors.centerIn: parent
                        text: "mic"
                        color: Appearance.colors.on_tertiary
                        filled: true
                        font.pixelSize: 20
                    }

                    Behavior on implicitWidth {
                        NumberAnimation { duration: 350; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.easings.expressiveFastSpatial }
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: Privacy.micActive ? 40 : 60
                    color: Appearance.colors.error_container
                    radius: 120
                    visible: Privacy.screenSharing

                    SequentialAnimation on opacity {
                        running: parent.visible
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.5; duration: 2000; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                    }

                    MaterialIcon {
                        anchors.centerIn: parent
                        text: "screen_share"
                        color: Appearance.colors.on_error_container
                        filled: false
                        font.pixelSize: 19
                    }
                    Behavior on implicitWidth {
                        NumberAnimation { duration: 350; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.easings.expressiveFastSpatial }
                    }
                }
            }
        }
    }

    property Component sidePillComponent: Component {
        Item {
            id: rootItem
            implicitWidth: content.implicitWidth + 12
            implicitHeight: content.implicitHeight

            RowLayout {
                id: content
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    topMargin: 6
                    bottomMargin: 6
                }
                spacing: 5

                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: Privacy.screenSharing ? 30 : 50
                    color: Appearance.colors.tertiary
                    radius: 120
                    visible: Privacy.micActive

                    SequentialAnimation on opacity {
                        running: parent.visible
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.5; duration: 2000; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                    }
                    
                    MaterialIcon {
                        anchors.centerIn: parent
                        text: "mic"
                        color: Appearance.colors.on_tertiary
                        filled: true
                        font.pixelSize: 19
                    }

                    Behavior on implicitWidth {
                        NumberAnimation { duration: 350; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.easings.expressiveFastSpatial }
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: Privacy.micActive ? 30 : 50
                    color: Appearance.colors.error_container
                    radius: 120
                    visible: Privacy.screenSharing

                    SequentialAnimation on opacity {
                        running: parent.visible
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.5; duration: 2000; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                    }

                    MaterialIcon {
                        anchors.centerIn: parent
                        text: "screen_share"
                        color: Appearance.colors.on_error_container
                        filled: false
                        font.pixelSize: 18
                    }

                    Behavior on implicitWidth {
                        NumberAnimation { duration: 350; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.easings.expressiveFastSpatial }
                    }
                }
            }
        }
    }

    property Component expandedComponent: Component {
        Item {
            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 8

                Text {
                    text: "Privacy Indicators"
                    color: Qt.alpha(Appearance.colors.on_surface, 0.7)
                    font.family: Config.options.fontFamily
                    font.pixelSize: 12
                    font.capitalization: Font.AllUppercase
                }

                Text {
                    text: root.statusLabel
                    color: Appearance.colors.on_surface
                    font.family: Config.options.fontFamily
                    font.pixelSize: 24
                    font.bold: true
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
