pragma Singleton
import QtQuick
import Quickshell

// User facing config for the shell. Nothing here should be too destructive, but be careful. \\
Singleton {
    property string fontFamily: "Roboto" // Global font family for the whole shell.

    property string barPosition: "top" // Position of the bar. Options: "top", "bottom" (if the bar shows up in the middle of your screen, its not top or bottom)
    property int barHeight: 50 // Height of the bar in pixels (not everything fits well outside of 50 at the moment)
    property int barCornerSize: 18 // Size of the rounded corners on the bar (0 to disable)

    property bool spinAlbumArt: true // Whether to spin album art in the media player

    property int persistentWorkspaceCount: 5 // Number of persistent workspaces to show

    property bool use24hrClock: false // Whether to use 24 hour clock in the time display

    property bool btShowOnEmpty: false // Whether to show the Bluetooth icon when no devices are connected

}
