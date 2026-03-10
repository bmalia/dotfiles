import QtQuick
import QtQuick.Effects
import qs.modules.common
import qs.services
import qs.modules.widgets.shapes
import "../../widgets/shapes/material-shapes.js" as MaterialShapes

Item {
    width: 40

    Rectangle {
        id: button
        z: 1
        anchors.fill: parent
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
            rotation: parent.hovered ? 90 : CookieButtonState.currentRotation

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

    RectangularShadow {
        anchors.fill: button
        z: 0
        radius: button.radius
        blur: 12
        spread: 1
        color: '#57000000'
        offset.x: 0
        offset.y: 2
    }
}
