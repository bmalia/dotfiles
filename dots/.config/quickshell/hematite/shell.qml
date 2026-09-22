//@ pragma UseQApplication
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import QtQuick
import Quickshell
import qs.modules.main
import qs.modules.common
import qs.modules.polkit

ShellRoot {
    Loader {
        id: root
        active: Config.ready
        sourceComponent: Main {}
    }

    Loader {
        id: polkitLoader
        active: Config.ready
        sourceComponent: Polkit {}
    }
    Component.onCompleted: {
        console.log("Shell started. Waiting for config load...");
    }
}