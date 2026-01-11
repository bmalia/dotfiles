import Quickshell
import QtQuick

Text {
    renderType: Text.NativeRendering
    font.family: "Material Symbols Rounded"
    property bool filled: false
    property real iconSize: 24
    property int weight: 400
    font.variableAxes: filled ? { "FILL": 1, "wght": weight } : { "FILL": 0, "wght": weight }
    font.pixelSize: iconSize
}