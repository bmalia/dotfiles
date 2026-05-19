import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.UPower
import qs.modules.common
import qs.modules.widgets.shapes
import qs.modules.widgets

PopupWindow {
    id: root
    color: "transparent"
    implicitHeight: 100
    implicitWidth: 200

    function open() {
        this.visible = true;
    }

    Rectangle {
        anchors.fill: parent
        color: Appearance.colors.surface
        radius: 10
    }
}