pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property bool sidebarVisible: false
    property bool caffinated: false // IdleInhibitor isn't in the downstream release yet, so this is unused for now
}