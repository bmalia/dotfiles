import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.UPower
import qs.modules.common
import qs.modules.widgets.shapes
import qs.modules.widgets
import qs.services
import "../../widgets/shapes/material-shapes.js" as MaterialShapes

Rectangle {
    id: root
    implicitWidth: content.implicitWidth + 16
    color: Qt.alpha(Appearance.colors.surface, Config.options.backgroundOpacity)
    radius: 12

    border.width: 1
    border.color: Qt.alpha(Appearance.colors.on_surface, 0.12)

    RowLayout {
        id: content
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: 8
            rightMargin: 8
        }
        spacing: 5
        
        Loader {
            id: batteryLoader
            sourceComponent: Battery {}
            Layout.fillHeight: true
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            visible: UPower.displayDevice.isLaptopBattery
            active: visible

            MouseArea {
                anchors.fill: parent
                onClicked: batteryPopup.open() // WIP
            }
        }

        MaterialIcon {
            text: BtService.materialSymbol
            iconSize: 23
            color: BtService.btStatus === "connected" ? Appearance.colors.primary : BtService.btStatus === "off" ? Qt.alpha(Appearance.colors.on_surface, 0.38) : Appearance.colors.on_surface
        }
    }
}
