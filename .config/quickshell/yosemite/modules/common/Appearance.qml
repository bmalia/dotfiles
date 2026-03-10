pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.platform

Singleton {
    id: root
    readonly property string filePath: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0] + "/quickshell/yosemite/modules/common/mdcolors.json"
    property alias colors: colorsJson
    property bool ready: false

    // Colors
    FileView {
        id: colorsFileView
        path: root.filePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterChanged: writeAdapter()
        onLoaded: {
            root.ready = true;
        }
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                console.log("Config file not found, creating default config at " + root.filePath);
                writeAdapter();
            }
        }
        adapter: JsonAdapter {
            id: colorsJson

            property bool darkMode: true

            property string background: "#1a1112"
            property string error: "#ffb4ab"
            property string error_container: "#93000a"
            property string inverse_on_surface: "#382e2e"
            property string inverse_primary: "#8f4952"
            property string inverse_surface: "#f0dedf"
            property string on_background: "#f0dedf"
            property string on_error: "#690005"
            property string on_error_container: "#ffdad6"
            property string on_primary: "#561d26"
            property string on_primary_container: "#ffdadc"
            property string on_primary_fixed: "#3b0712"
            property string on_primary_fixed_variant: "#72333b"
            property string on_secondary: "#44292c"
            property string on_secondary_container: "#ffdadc"
            property string on_secondary_fixed: "#2c1517"
            property string on_secondary_fixed_variant: "#5c3f41"
            property string on_surface: "#f0dedf"
            property string on_surface_variant: "#d7c1c2"
            property string on_tertiary: "#442b06"
            property string on_tertiary_container: "#ffddb5"
            property string on_tertiary_fixed: "#2a1800"
            property string on_tertiary_fixed_variant: "#5d411b"
            property string outline: "#9f8c8d"
            property string outline_variant: "#524344"
            property string primary: "#ffb2b9"
            property string primary_container: "#72333b"
            property string primary_fixed: "#ffdadc"
            property string primary_fixed_dim: "#ffb2b9"
            property string scrim: "#000000"
            property string secondary: "#e5bdbf"
            property string secondary_container: "#5c3f41"
            property string secondary_fixed: "#ffdadc"
            property string secondary_fixed_dim: "#e5bdbf"
            property string shadow: "#000000"
            property string surface: "#1a1112"
            property string surface_bright: "#413737"
            property string surface_container: "#271d1e"
            property string surface_container_high: "#312828"
            property string surface_container_highest: "#3d3233"
            property string surface_container_low: "#22191a"
            property string surface_container_lowest: "#140c0d"
            property string surface_dim: "#1a1112"
            property string surface_tint: "#ffb2b9"
            property string surface_variant: "#524344"
            property string tertiary: "#e8c08e"
            property string tertiary_container: "#5d411b"
            property string tertiary_fixed: "#ffddb5"
            property string tertiary_fixed_dim: "#e8c08e"
        }
    }

    // Easing Curves (https://m3.material.io/styles/motion/overview/specs)
        // Spatial: Used for movement, rotations, scaling, etc.
        // Effects: Used for opacity, color, etc.
        // Expressive: Bouncier, used for hero elements and important actions
        // Standard: Smoother, used for general UI elements and less important actions
    property var easings: {
        "expressiveFastSpatial": [0.42, 1.67, 0.21, 0.90, 1, 1], // Duration 350ms
        "expressiveDefaultSpatial": [0.38, 1.21, 0.22, 1.00, 1, 1], // Duration 500ms
        "expressiveSlowSpatial": [0.39, 1.29, 0.35, 0.98, 1, 1], // Duration 650ms
        "expressiveFastEffects": [0.31, 0.94, 0.34, 1.00, 1, 1], // Duration 150ms
        "expressiveDefaultEffects": [0.34, 0.80, 0.34, 1.00, 1, 1], // Duration 200ms
        "expressiveSlowEffects": [0.34, 0.88, 0.34, 1.00, 1, 1], // Duration 300ms

        "standardFastSpatial": [0.27, 1.06, 0.18, 1.00, 1, 1], // Duration 350ms
        "standardDefaultSpatial": [0.27, 1.06, 0.18, 1.00, 1, 1], // Duration 500ms
        "standardSlowSpatial": [0.27, 1.06, 0.18, 1.00, 1, 1], // Duration 650ms
        "standardFastEffects": [0.31, 0.94, 0.34, 1.00, 1, 1], // Duration 150ms
        "standardDefaultEffects": [0.34, 0.80, 0.34, 1.00, 1, 1], // Duration 200ms
        "standardSlowEffects": [0.34, 0.88, 0.34, 1.00, 1, 1], // Duration 300ms
    }
}
