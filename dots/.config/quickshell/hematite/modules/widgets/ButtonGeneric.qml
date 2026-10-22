import QtQuick
import qs.modules.common

Rectangle {
    id: root

    enum ButtonType {
        Filled,
        Tonal,
        Outlined,
        Text
    }

    property bool checked
    property bool disabled
    property int type: ButtonGeneric.Filled // Really strange type mismatch

    property color activeColor: Appearance.colors.primary
    property color activeFgColor: Appearance.colors.on_primary
    property color inactiveColor: Appearance.colors.secondary_container
    property color inactiveFgColor: Appearance.colors.on_secondary_container
    property color disabledColor: Qt.alpha(Appearance.colors.on_surface, 0.1)
    property color disabledFgColor: Qt.alpha(Appearance.colors.on_surface, 0.4)

    property bool radiusMorph: true
}
