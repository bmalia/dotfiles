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
    property real normalizedProgress: {
        const raw = Number(progress ?? 0);
        if (!isFinite(raw))
            return 0;
        if (raw > 1 && raw <= 100)
            return Math.max(0, Math.min(1, raw / 100));
        return Math.max(0, Math.min(1, raw));
    }
    property real displayedProgress: normalizedProgress

    color: hovered ? Appearance.colors.surface_variant : Appearance.colors.surface
    radius: activePlayer.isPlaying ? 90 : 12
    border.width: 1
    border.color: Qt.alpha(Appearance.colors.on_surface, 0.12)

    onNormalizedProgressChanged: displayedProgress = normalizedProgress

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
                thickness: 1.5
                color: Appearance.colors.primary
                trackColor: Qt.alpha(Appearance.colors.on_surface, 0.12)
                waveAmplitude: root.activePlayer.isPlaying ? 0.5 : 0
                waveCount: 9
                progressGap: 0
            }

            Component {
                id: artComponent
                ClippingWrapperRectangle {
                    implicitWidth: artProgress.width - 1.5 * 2
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
                    implicitWidth: artProgress.width - 1.5 * 2
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

            Layout.maximumWidth: 300

            Text {
                id: title
                text: root.activePlayer.trackTitle || "Unknown Title"
                font.family: Config.options.fontFamily
                font.bold: true
                font.pixelSize: 13
                color: Appearance.colors.on_surface
                elide: Text.ElideRight
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
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }

    Behavior on radius {
        NumberAnimation {
            duration: 500
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
