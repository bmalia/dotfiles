pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.widgets
import qs.services

Item {
    id: root

    property string pageId: "media"
    property string title: "Media"
    property string materialIcon: "music_note"
    property int priority: 10
    property bool hasCollapsedContent: true
    property bool isActive: MprisController.activePlayer !== null
    property MprisPlayer activePlayer: MprisController.activePlayer
    property int collapsedWidth: 0
    property int sidePillWidth: 0

    property list<real> cavaData: [0, 0, 0, 0]

    property real progress: activePlayer ? activePlayer.position / activePlayer.length : 0

    property Component collapsedComponent: Component {
        Item {
            id: rootItem
            implicitWidth: content.implicitWidth + 32
            implicitHeight: content.implicitHeight

            RowLayout {
                id: content
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: -5 // 1
                    topMargin: 6
                    bottomMargin: 6
                }
                spacing: 6

                Item {
                    Layout.fillHeight: true
                    implicitWidth: height

                    Loader {
                        id: artCenter
                        anchors.centerIn: parent
                        z: 0
                        sourceComponent: root.activePlayer.trackArtUrl ? artComponent : iconComponent
                    }

                    WavyCircularProgress {
                        id: artProgress
                        anchors.centerIn: parent
                        z: 1
                        width: Math.max(10, parent.height - 8)
                        height: width
                        progress: root.progress
                        thickness: 2
                        color: Appearance.colors.primary
                        trackColor: Qt.alpha(Appearance.colors.on_surface, 0.12)
                        waveAmplitude: root.activePlayer.isPlaying ? 0.65 : 0
                        scrollSpeed: 0.05
                        waveCount: 9
                        progressGap: 0
                    }

                    Component {
                        id: artComponent
                        ClippingWrapperRectangle {
                            implicitWidth: artProgress.width - 4 * 2
                            implicitHeight: implicitWidth
                            radius: 99

                            Image {
                                anchors.fill: parent
                                source: root.activePlayer.trackArtUrl
                                fillMode: Image.PreserveAspectCrop
                            }
                        }
                    }

                    Component {
                        id: iconComponent
                        Rectangle {
                            implicitWidth: artProgress.width * 2
                            implicitHeight: implicitWidth
                            color: "transparent"

                            MaterialIcon {
                                anchors.centerIn: parent

                                text: "music_note"
                                filled: true
                                font.pixelSize: Math.max(12, parent.height * 0.3)
                                color: Appearance.colors.primary
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.maximumWidth: 200
                    spacing: 0
                    Text {
                        text: root.activePlayer.trackTitle || "Unknown Title"
                        color: Appearance.colors.on_surface
                        font.family: Config.options.fontFamily
                        font.pixelSize: 14
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.alignment: Qt.AlignHCenter
                        Layout.maximumWidth: parent.Layout.maximumWidth
                    }

                    Text {
                        text: root.activePlayer.trackArtist
                        visible: root.activePlayer.trackArtist.length > 0
                        color: Qt.alpha(Appearance.colors.on_surface, 0.72)
                        font.family: Config.options.fontFamily
                        font.pixelSize: 9
                        elide: Text.ElideRight
                        Layout.alignment: Qt.AlignHCenter
                        Layout.maximumWidth: parent.Layout.maximumWidth
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.leftMargin: 5
                    Layout.topMargin: 9
                    Layout.bottomMargin: 9
                    implicitWidth: visualizer.implicitWidth
                    color: "transparent"

                    RowLayout {
                        id: visualizer
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            left: parent.left
                        }
                        spacing: 2

                        Repeater {
                            model: root.cavaData
                            delegate: Rectangle {
                                required property var modelData
                                implicitWidth: 2
                                implicitHeight: Math.max(implicitWidth, visualizer.height * modelData)
                                color: Appearance.colors.primary
                                radius: 5
                            }
                        }
                    }
                }
            }
        }
    }

    property Component sidePillComponent: Component {
        Item {
            id: rootItem
            implicitWidth: content.implicitWidth + 40
            implicitHeight: content.implicitHeight

            RowLayout {
                id: content
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: 7
                }
                spacing: 8

                Loader {
                    id: artLoader
                    Layout.fillHeight: true
                    sourceComponent: root.activePlayer.trackArtUrl ? artComponent : icon

                    Component {
                        id: artComponent
                        ClippingWrapperRectangle {
                            implicitWidth: content.height
                            implicitHeight: implicitWidth
                            radius: 15

                            Image {
                                anchors.fill: parent
                                source: root.activePlayer.trackArtUrl
                                fillMode: Image.PreserveAspectCrop
                            }
                        }
                    }

                    Component {
                        id: icon
                        Rectangle {
                            implicitWidth: content.height
                            implicitHeight: implicitWidth
                            color: "transparent"
                            MaterialIcon {
                                anchors.centerIn: parent
                                text: "music_note"
                                filled: true
                                font.pixelSize: 20
                                color: Appearance.colors.tertiary
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.rightMargin: 5
                    implicitWidth: visualizer.implicitWidth
                    color: "transparent"

                    RowLayout {
                        id: visualizer
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            left: parent.left
                        }
                        spacing: 2

                        Repeater {
                            model: root.cavaData
                            delegate: Rectangle {
                                required property var modelData
                                implicitWidth: 2
                                implicitHeight: Math.max(implicitWidth, (visualizer.height * 0.7) * modelData)
                                color: Appearance.colors.primary
                                radius: 5
                            }
                        }
                    }
                }
            }
        }
    }

    property Component expandedComponent: Component {
        Item {
            id: rootItem
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

                RowLayout {
                    spacing: 0
                    Layout.maximumWidth: rootItem.width
                    ClippingWrapperRectangle {
                        Layout.fillHeight: true
                        implicitWidth: height
                        radius: 30
                        Layout.margins: 40

                        Image {
                            anchors.fill: parent
                            source: root.activePlayer.trackArtUrl
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.maximumWidth: rootItem.width * 0.35
                        spacing: 10

                        Text {
                            text: root.activePlayer.trackTitle || "Nothing Playing"
                            font.pixelSize: 24
                            font.bold: true
                            font.family: Config.options.fontFamily
                            color: Appearance.colors.on_surface
                            Layout.alignment: Qt.AlignLeft
                            Layout.maximumWidth: parent.Layout.maximumWidth
                            elide: Text.ElideRight
                        }

                        Text {
                            text: root.activePlayer.trackArtist || "-"
                            font.pixelSize: 16
                            font.bold: false
                            font.family: Config.options.fontFamily
                            color: Appearance.colors.on_surface_variant
                            Layout.alignment: Qt.AlignLeft
                            Layout.maximumWidth: parent.Layout.maximumWidth
                            elide: Text.ElideRight
                        }

                        Text {
                            text: root.activePlayer.trackAlbum || "-"
                            font.pixelSize: 16
                            font.bold: false
                            font.family: Config.options.fontFamily
                            color: Appearance.colors.on_surface_variant
                            Layout.alignment: Qt.AlignLeft
                            Layout.maximumWidth: parent.Layout.maximumWidth
                            elide: Text.ElideRight
                        }

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 20
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: false
                            spacing: 5
                            Text {
                                color: Appearance.colors.on_surface_variant
                                font.family: Config.options.fontFamily
                                font.pixelSize: 10
                                font.variableAxes: {"wdth": 120, "wght": 500}
                                text: new Date(root.activePlayer.position * 1000).toISOString().substr(14, 5)
                                
                            }

                            ClippingRectangle {
                                Layout.fillWidth: true
                                implicitHeight: 10
                                radius: 5
                                color: Appearance.colors.tertiary_container
                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    implicitHeight: parent.height
                                    width: parent.width * root.progress
                                    color: Appearance.colors.tertiary

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 1000
                                            easing.type: Easing.Linear
                                        }
                                    }
                                }
                            }

                            Text {
                                color: Appearance.colors.on_surface_variant
                                font.family: Config.options.fontFamily
                                font.pixelSize: 10
                                font.variableAxes: {"wdth": 120, "wght": 500}
                                text: new Date(root.activePlayer.length * 1000).toISOString().substr(14, 5)

                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: false
                            spacing: 5
                            Layout.topMargin: 5

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.horizontalStretchFactor: 2
                                radius: 25
                                color: Appearance.colors.secondary_container

                                MaterialIcon {
                                    anchors.centerIn: parent
                                    text: "skip_previous"
                                    filled: true
                                    font.pixelSize: 28
                                    color: Appearance.colors.on_secondary_container
                                }
                            }

                            Rectangle {
                                id: playButton
                                Layout.fillWidth: true
                                Layout.horizontalStretchFactor: 3
                                implicitHeight: 53
                                radius: 10
                                color: root.activePlayer.isPlaying ? Appearance.colors.primary : Appearance.colors.secondary_container

                                MaterialIcon {
                                    anchors.centerIn: parent
                                    text: root.activePlayer.isPlaying ? "pause" : "play_arrow"
                                    filled: true
                                    font.pixelSize: 28
                                    color: root.activePlayer.isPlaying ? Appearance.colors.on_primary : Appearance.colors.on_secondary_container
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.horizontalStretchFactor: 2
                                Layout.fillHeight: true
                                radius: 25
                                color: Appearance.colors.secondary_container

                                MaterialIcon {
                                    anchors.centerIn: parent
                                    text: "skip_next"
                                    filled: true
                                    font.pixelSize: 28
                                    color: Appearance.colors.on_secondary_container
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                implicitWidth: height * 0.85
                                radius: 25
                                color: Appearance.colors.secondary_container

                                MaterialIcon {
                                    anchors.centerIn: parent
                                    text: "shuffle"
                                    filled: true
                                    font.pixelSize: 24
                                    color: Appearance.colors.on_secondary_container
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                implicitWidth: height * 0.85
                                radius: 25
                                color: Appearance.colors.secondary_container

                                MaterialIcon {
                                    anchors.centerIn: parent
                                    text: "repeat"
                                    filled: true
                                    font.pixelSize: 24
                                    color: Appearance.colors.on_secondary_container
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 20
                    }
                }
            }
        }
    }

    Timer {
        id: progressPollTimer
        interval: 1000
        running: root.activePlayer
        repeat: true

        onTriggered: {
            root.progress = root.activePlayer.position / root.activePlayer.length;
        }
    }

    Process { // Cava visualizer process - Inspired by Devvvmn's implementation in their shell
        id: cava
        command: ["bash", "-c", "cava -p ~/.config/cava/hematite.cfg 2>/dev/null"]
        running: root.activePlayer
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: line => {
                let parts = line.trim().split(" ");
                if (parts.length < 4)
                    return;
                function normalise(v) {
                    let value = parseInt(v);
                    return isNaN(value) ? 0.05 : Math.max(0.05, Math.min(1.0, value / 600.0));
                }

                for (let i = 0; i < parts.length; i++) { // Bar count-agnostic list
                    root.cavaData[i] = normalise(parts[i]);
                }
            }
        }
    }
}
