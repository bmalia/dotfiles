pragma Singleton
import QtQuick
import Quickshell

Singleton {
    <* for name, value in colors *>
    property color {{name}}: "{{value.default.hex}}"
    <* endfor *>
}
