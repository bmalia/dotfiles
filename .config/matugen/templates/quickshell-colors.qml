pragma Singleton
import QtQuick
import Quickshell

Singleton {
    <* if {{ is_dark_mode }} *>
    property bool darkMode: true
    <* else *>
    property bool darkMode: false
    <* endif *>
    property url image: "{{image}}"
    property color clockColor: "{{colors.primary.dark.hex}}"
    <* for name, value in colors *>
    property color {{name}}: "{{value.default.hex}}"
    <* endfor *>
}
