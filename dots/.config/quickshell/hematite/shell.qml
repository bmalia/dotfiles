//@ pragma UseQApplication
//@ pragma Env QSG_RHI_BACKEND=vulkan
//@ pragma Env MALLOC_TRIM_THRESHOLD_=65536
//@ pragma Env MALLOC_ARENA_MAX=2
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
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
