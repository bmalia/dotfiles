//@ pragma UseQApplication
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import QtQuick
import Quickshell
import qs.modules.bar
import qs.modules.common

ShellRoot {
    Loader {
        id: root
        active: Config.ready
        sourceComponent: Bar {}
    }
}