import Quickshell
import QtQuick

Text {
    renderType: Text.NativeRendering
    font.family: "Material Symbols Rounded"
    property boolean filled: false
    property real iconSize: 24
    font.variableAxes: filled ? { "FILL": 1 } : { "FILL": 0 }
}