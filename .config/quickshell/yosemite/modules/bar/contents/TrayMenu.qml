pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common

PopupWindow {
    id: root
    required property QsMenuHandle trayItemMenu
    property string trayItemId: ""
    color: "transparent"
    signal menuClosed
    signal menuOpened(qsWindow: var)
    implicitWidth: {
        let result = 0;
        for (let child of stackView.children) {
            result = Math.max(child.implicitWidth, result);
        }
        return result
    }
    implicitHeight: {
        let result = 0;
        for (let child of stackView.children) {
            result = Math.max(child.implicitHeight, result);
        }
        return result
    }

    MouseArea {
        anchors.fill: parent

        Rectangle {
            anchors {
                fill: parent
            }

            color: Appearance.colors.surface
            radius: 10

            opacity: 0
            Component.onCompleted: opacity = 1

            StackView {
                id: stackView
                anchors.fill: parent

                initialItem: SubMenu {
                    handle: root.trayItemMenu
                }
            }
        }

        acceptedButtons: Qt.BackButton | Qt.RightButton
        onPressed: event => {
            if ((event.button === Qt.BackButton || event.button === Qt.RightButton) && stackView.depth > 1)
                stackView.pop();
        }
    }

    function open() {
        root.visible = true;
        root.menuOpened(root);
    }

    function close() {
        root.visible = false;
        while (stackView.depth > 1)
            stackView.pop();
        root.menuClosed();
    }

    component SubMenu: ColumnLayout {
        id: submenu
        required property QsMenuHandle handle
        property bool isSubMenu: false
        property bool shown: false
        opacity: shown ? 1 : 0
        spacing: 0

        Component.onCompleted: shown = true
        StackView.onActivating: shown = true
        StackView.onDeactivating: shown = false
        StackView.onRemoved: destroy()

        QsMenuOpener {
            id: menuOpener
            menu: submenu.handle
        }

        Loader {
            Layout.fillWidth: true
            visible: submenu.isSubMenu
            active: visible
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Appearance.colors.outline
            Layout.topMargin: 4
            Layout.bottomMargin: 4
        }

        Repeater {
            id: menuEntries
            property bool iconColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].icon.length > 0)
                        return true;
                }
                return false;
            }
            property bool interactionColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].buttonType !== QsMenuButtonType.None)
                        return true;
                }
                return false;
            }
            model: menuOpener.children
            delegate: TrayMenuEntry {
                required property QsMenuEntry modelData
                menuEntry: modelData
                iconColumn: menuEntries.iconColumnNeeded
                interactionColumn: menuEntries.interactionColumnNeeded

                onDismiss: root.close()
                onOpenSubmenu: handle => {
                    stackView.push(subMenuComponent.createObject(null, {
                        handle: handle,
                        isSubMenu: true
                    }));
                }
            }
        }
    }
    Component {
        id: subMenuComponent
        SubMenu {}
    }
}
