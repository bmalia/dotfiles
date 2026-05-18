pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.modules.common

Rectangle {
    id: root
    required property QsMenuEntry menuEntry
    property bool iconColumn: false
    property bool interactionColumn: false
    readonly property bool hasIcon: menuEntry.icon.length > 0
    readonly property bool hasInteraction: menuEntry.buttonType !== QsMenuButtonType.None

    signal dismiss()
    signal openSubmenu(handle: QsMenuHandle)

    color: menuEntry.isSeparator ? Appearance.colors.outline_variant : "transparent"
    implicitHeight: menuEntry.isSeparator ? 1 : 36
    implicitWidth: content.implicitWidth + 24
    Layout.fillWidth: true
    Layout.topMargin: menuEntry.isSeparator ? 4 : 0
    Layout.bottomMargin: menuEntry.isSeparator ? 4 : 0

    MouseArea {
        anchors.fill: parent
        enabled: !root.menuEntry.isSeparator
        onClicked: {
            if (root.menuEntry.hasChildren) {
                root.openSubmenu(root.menuEntry);
            } else {
                root.menuEntry.triggered();
                root.dismiss();
            }
        }
    }

    RowLayout {
        id: content
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: 12
            rightMargin: 12
        }

        Item {
            visible: root.hasInteraction || root.interactionColumn
            implicitHeight: 20
            implicitWidth: 20

            Loader {
                anchors.fill: parent
                active: root.menuEntry.buttonType === QsMenuButtonType.RadioButton

                sourceComponent: RadioButton {
                    padding: 0
                    checked: root.menuEntry.checkState === Qt.Checked
                }
            }

            Loader {
                anchors.fill: parent
                active: root.menuEntry.buttonType === QsMenuButtonType.CheckBox && root.menuEntry.checkState !== Qt.Unchecked

                sourceComponent: MaterialIcon {
                    text: root.menuEntry.checkState === Qt.PartiallyChecked ? "check_indeterminate_small" : "check"
                    iconSize: 20
                }
            }
        }

        Item {
            visible: root.hasIcon || root.iconColumn
            implicitHeight: 20
            implicitWidth: 20

            Loader {
                anchors.centerIn: parent
                active: root.menuEntry.icon.length > 0
                sourceComponent: IconImage {
                    asynchronous: true
                    source: root.menuEntry.icon
                    implicitSize: 20
                    mipmap: true
                }
            }
        }

        Text {
            id: label
            text: root.menuEntry.text
            font.pixelSize: 16
            color: Appearance.colors.on_surface
            Layout.fillWidth: true
        }

        Loader {
            active: root.menuEntry.hasChildren

            sourceComponent: MaterialIcon {
                text: "chevron_right"
                iconSize: 20
                color: Appearance.colors.on_surface_variant
            }
        }
    }

}