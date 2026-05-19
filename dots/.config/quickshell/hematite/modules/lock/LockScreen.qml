import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.modules.common

Scope {
    id: root

    property Component lockSurface: WlSessionLockSurface {
        id: lockSurface
        color: "transparent"

        Loader {
            active: GlobalVars.persistent.screenLocked
            anchors.fill: parent
            opacity: active ? 1 : 0

            sourceComponent: LockSurface {
                context: lockContext
            }
            
            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                }
            }
        }
    }
    LockContext {
        id: lockContext

        onUnlocked: {
            // Unlock the screen before exiting, or the compositor will display a
            // fallback lock you can't interact with.
            GlobalVars.persistent.screenLocked = false
        }
    }

    WlSessionLock {
        id: lock
        locked: GlobalVars.persistent.screenLocked
        surface: root.lockSurface
    }

    function lock() {
        GlobalVars.persistent.screenLocked = true
    }

    IpcHandler {
        target: "lock"

        function activate(): void {
            console.log("Locking screen due to IPC request")
            root.lock()
        }
    }

}