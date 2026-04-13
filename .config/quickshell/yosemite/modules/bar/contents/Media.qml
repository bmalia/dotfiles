pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.widgets
import qs.services

Rectangle {
    id: root
    implicitWidth: content.implicitWidth + 3
    readonly property var activePlayer: MprisController.activePlayer
    property bool hovered: false
    property bool hasTrackArt: root.activePlayer.trackArtUrl !== ""
    property real progress: activePlayer.position / activePlayer.length
    property real displayedProgress: progress

    color: Appearance.colors.surface
    radius: 90
    border.width: 1
    border.color: Qt.alpha(Appearance.colors.on_surface, 0.12)

    Timer {
        id: progressPollTimer
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            const player = root.activePlayer;
            const length = Number(player?.length ?? 0);
            const position = Number(player?.position ?? 0);
            const fallback = Number(player?.progress ?? 0);

            let sampled = 0;
            if (isFinite(length) && length > 0 && isFinite(position))
                sampled = position / length;
            else if (isFinite(fallback))
                sampled = fallback;

            sampled = Math.max(0, Math.min(1, sampled));
            if (Math.abs(sampled - root.displayedProgress) > 0.0005)
                root.displayedProgress = sampled;
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        z: 10
        propagateComposedEvents: true
    }

    RowLayout {
        id: content
        spacing: 2
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 0
        }

        Item {
            Layout.fillHeight: true
            implicitWidth: height

            Loader {
                id: artCenter
                anchors.centerIn: parent
                z: 0
                sourceComponent: root.hasTrackArt ? artComponent : iconComponent
            }

            WavyCircularProgress {
                id: artProgress
                anchors.centerIn: parent
                z: 1
                width: Math.max(10, parent.height - 8)
                height: width
                progress: root.displayedProgress
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
                    implicitWidth: artProgress.width - 2 * 2
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
                    implicitWidth: artProgress.width - 2 * 2
                    implicitHeight: implicitWidth
                    radius: 99
                    color: Qt.alpha(Appearance.colors.on_surface, 0.08)

                    MaterialIcon {
                        anchors.centerIn: parent
                        text:"music_note"
                        filled: true
                        font.pixelSize: Math.max(12, parent.height * 0.55)
                        color: Qt.alpha(Appearance.colors.on_surface, 0.75)
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillHeight: true
            spacing: 0
            Layout.rightMargin: 12

            Layout.maximumWidth: 250

            Text {
                id: title
                text: root.activePlayer.trackTitle || "Unknown Title"
                font.family: Config.options.fontFamily
                font.bold: true
                font.pixelSize: 13
                color: Appearance.colors.on_surface
                elide: Text.ElideMiddle
                Layout.fillWidth: true
            }

            Text {
                visible: root.activePlayer.trackArtist !== ""
                id: artist
                text: root.activePlayer.trackArtist
                font.family: Config.options.fontFamily
                font.pixelSize: 9
                color: Qt.alpha(Appearance.colors.on_surface, 0.7)
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        Rectangle {
            visible: root.activePlayer.canControl && root.hovered
            id: controlsContainer
            Layout.fillHeight: true
            Layout.margins: 6
            implicitWidth: controls.implicitWidth + 6 * 2
            radius: 90
            color: Qt.alpha(Appearance.colors.surface_variant, 0.6)

            RowLayout {
                id: controls
                anchors.fill: parent
                spacing: 5
                anchors.leftMargin: 6
                anchors.rightMargin: 6

                IconButton {
                    visible: root.activePlayer.canGoPrevious
                    implicitHeight: 15
                    implicitWidth: height
                    icon.text: "skip_previous"
                    icon.color: Appearance.colors.on_surface
                    icon.weight: 300
                    icon.filled: true
                    icon.font.pixelSize: 20
                    backgroundColor: "transparent"

                    onClicked: root.activePlayer.previous()
                }

                IconButton {
                    visible: root.activePlayer.canPlayPause
                    implicitHeight: 15
                    implicitWidth: height
                    icon.text: root.activePlayer.isPlaying ? "pause" : "play_arrow"
                    icon.color: Appearance.colors.on_surface
                    icon.weight: 300
                    icon.filled: true
                    icon.font.pixelSize: 20
                    backgroundColor: "transparent"

                    onClicked: root.activePlayer.togglePlaying()
                }

                IconButton {
                    visible: root.activePlayer.canGoNext
                    implicitHeight: 15
                    implicitWidth: height
                    icon.text: "skip_next"
                    icon.color: Appearance.colors.on_surface
                    icon.weight: 300
                    icon.filled: true
                    icon.font.pixelSize: 20
                    backgroundColor: "transparent"

                    onClicked: root.activePlayer.next()
                }
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }

    Behavior on displayedProgress {
        NumberAnimation {
            duration: 250
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.easings.expressiveFastSpatial
        }
    }
}
