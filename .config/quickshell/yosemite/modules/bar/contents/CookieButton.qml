import QtQuick
import Quickshell
import Quickshell.Services.UPower
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs.modules.widgets.shapes
import "../../widgets/shapes/material-shapes.js" as MaterialShapes

    Rectangle {
        width: 40
        color: Appearance.colors.primary_container
        radius: 99
        property var hovered: false

        ShapeCanvas {
            implicitWidth: parent.width - 15
            implicitHeight: parent.height - 15
            anchors.centerIn: parent
            z: 2
            roundedPolygon: parent.hovered ? MaterialShapes.getClover4Leaf() : CookieButtonState.currentShape
            color: Appearance.colors.on_primary_container
            rotation: parent.hovered ? 90: CookieButtonState.currentRotation

            Behavior on rotation {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true
            onExited: parent.hovered = false
        }
}