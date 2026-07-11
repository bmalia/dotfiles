import qs.modules.common
import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls

TextField {
    id: root
    Material.theme: Material.System
    Material.accent: Appearance.colors.primary
    Material.primary: Appearance.colors.primary
    Material.background: Appearance.colors.surface
    Material.foreground: Appearance.colors.on_surface
    Material.containerStyle: Material.Outlined
    renderType: Text.QtRendering

    selectedTextColor: Appearance.colors.on_secondary_container
    selectionColor: Appearance.colors.secondary_container
    placeholderTextColor: Appearance.colors.on_surface_variant
    clip: true

    font {
        family: Config.options.fontFamily
        pixelSize: 15
        hintingPreference: Font.PreferFullHinting
    }
    wrapMode: TextEdit.Wrap

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        cursorShape: Qt.IBeamCursor
    }
}