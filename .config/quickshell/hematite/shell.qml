//@ pragma UseQApplication
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import QtQuick
import Quickshell
import qs.modules.bar
import qs.modules.island
import qs.modules.common

ShellRoot {
    Loader {
        id: root
        active: Config.ready
        sourceComponent: Bar {}
    }
    Loader {
        id: islandLoader
        active: Config.ready
        sourceComponent: Island {}
    }
    Component.onCompleted: {
        console.log("Shell started. Waiting for config load...");
    }
}