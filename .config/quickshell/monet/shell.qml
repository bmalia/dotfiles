//@ pragma UseQApplication
//@ pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.modules.bar

ShellRoot {
    Loader {
        id: root

        sourceComponent: Bar{}
    }
}