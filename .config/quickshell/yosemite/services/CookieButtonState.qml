pragma Singleton
import QtQuick
import Quickshell
import qs.modules.widgets.shapes
import qs.modules.common
import "../modules/widgets/shapes/material-shapes.js" as MaterialShapes

Singleton {
    id: root
    property var currentShape: MaterialShapes.getFlower()
    property int currentRotation: 0
    property var persistentShape: MaterialShapes.getFlower()
    property var persistentRotation: 0

    Timer {
        id: shapeResetTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            root.currentShape = root.persistentShape;
            root.currentRotation = root.persistentRotation;
        }
    }

    function setTransientShape(shape, rotation) {
        root.currentShape = shape;
        root.currentRotation = rotation;
        shapeResetTimer.restart();
    }

    function setPersistentShape(shape, rotation) {
        root.persistentShape = shape;
        root.persistentRotation = rotation;
        root.currentShape = shape;
        root.currentRotation = rotation;
        shapeResetTimer.stop();
    }
}