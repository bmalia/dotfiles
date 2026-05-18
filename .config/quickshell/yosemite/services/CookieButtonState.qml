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
    property int transientDuration: 500

    Timer {
        id: shapeResetTimer
        interval: root.transientDuration
        running: false
        repeat: false
        onTriggered: {
            root.currentShape = root.persistentShape;
            root.currentRotation = root.persistentRotation;
        }
    }

    function setTransientShape(shape, rotation, duration) { // Sets a shape that resets to the default after a short delay
        root.currentShape = shape;
        root.currentRotation = rotation;
        root.transientDuration = duration;
        shapeResetTimer.restart();
    }

    function setPersistentShape(shape, rotation) { // Sets a shape that remains until changed again underneath transient shapes
        root.persistentShape = shape;
        root.persistentRotation = rotation;
        root.currentShape = shape;
        root.currentRotation = rotation;
        shapeResetTimer.stop();
    }
}