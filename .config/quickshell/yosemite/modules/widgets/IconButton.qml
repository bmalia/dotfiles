import Quickshell
import QtQuick
import qs.modules.common
import qs.modules.widgets

Rectangle {
    id: root
    implicitWidth: height
    implicitHeight: 32
    color: hovered ? hoveredColor : backgroundColor
    radius: 90
    property bool hovered: false
    
    signal clicked
    property alias icon: materialIcon
    property color hoveredColor: Appearance.colors.surface_variant
    property color backgroundColor: Appearance.colors.surface

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: root.clicked()
    }

    MaterialIcon {
        id: materialIcon
        anchors.centerIn: parent
    }
}