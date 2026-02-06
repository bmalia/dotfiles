pragma Singleton
import QtQuick
import Quickshell

// User facing config for the shell. Nothing here should be too destructive, but be careful. \\
Singleton {
    property string fontFamily: "Google Sans" // Global font family for the whole shell.

    property string barStyle: "edge" // Style of the bar. Options: "edge", "floating"
    property string barPosition: "top" // Position of the bar. Options: "top", "bottom" (if the bar shows up in the middle of your screen, its not top or bottom)
    property int barHeight: 50 // Height of the bar in pixels (not everything fits well outside of 50 at the moment)
    property int barCornerSize: 23 // Size of the rounded corners on the bar (0 to disable)

    property bool spinAlbumArt: true // Whether to spin album art in the media player

    property int persistentWorkspaceCount: 5 // Number of persistent workspaces to show

    property bool use24hrClock: false // Whether to use 24 hour clock in the time display

    property bool batteryUseErrorContainer: true // Whether to use error container colors for low battery (less noticable) or just error colors (more noticable)
    property real batteryLowThreshold: 0.15 // Battery percentage threshold to consider battery as low (0.0 - 1.0)

    property bool btShowOnEmpty: true // Whether to show the Bluetooth icon when no devices are connected

}
