pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.modules.common

MouseArea {
    id: root
    required property SystemTrayItem item
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitHeight: 20
    implicitWidth: 20
    onPressed: (event) => {
        if (event.button === Qt.LeftButton)
            item.activate()
        
        else if (event.button === Qt.RightButton) {
            item.display(root.QsWindow.window, root.QsWindow.itemPosition(root).x, root.y + root.height);
        }
        event.accepted = true;
    }
    cursorShape: Qt.PointingHandCursor

    signal menuOpened(qsWindow: var)
    signal menuClosed()

    IconImage {
        anchors.fill: parent
        source: root.item.icon
    }

    /* // WIP, wayland crash issue
    Loader {
        id: menu
        function open() {
            this.active = true;
        }
        active: false
        sourceComponent: TrayMenu {
            Component.onCompleted: this.open();
            trayItemMenu: root.item.menu
            trayItemId: root.item.id
            anchor {
                window: root.QsWindow.window
                item: root
                gravity: Config.options.barPosition === 0
                        ? Edges.Top | Edges.Right : Edges.Bottom | Edges.Right
                edges: Config.options.barPosition === 0
                        ? Edges.Bottom | Edges.Right : Edges.Top | Edges.Right
            }
            onMenuOpened: (window) => root.menuOpened(window);
            onMenuClosed: {
                root.menuClosed();
                menu.active = false;
            }
        }
    }
    */
}