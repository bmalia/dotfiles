//@ pragma UseQApplication
import QtQuick
import Quickshell
import qs.modules.bar
import qs.modules.sidepanel
import qs.modules.common

ShellRoot {
    Loader {
        id: root

        sourceComponent: Bar{}
    }

    Loader {
        id: sidePanelLoader

        active: GlobalVars.sidebarVisible

        sourceComponent: SidePanel{}
    }
}