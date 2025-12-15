import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs

ClippingRectangle {
    antialiasing: true
    id: container
    color: activePlayer.playbackState === MprisPlaybackState.Playing ? Colors.primary_container : Colors.surface_container
    radius: 99
    implicitWidth: activePlayer ? albumart.width + info.width + 20 + (hovered ? buttonWrapper.width + buttonWrapper.Layout.leftMargin + buttonWrapper.Layout.rightMargin : 0) : 0
    implicitHeight: activePlayer ? 40 : 0
    readonly property MprisPlayer activePlayer: MprisController.activePlayer // Uses the active player determined by MprisController
    visible: !!activePlayer

    Timer {
        running: activePlayer?.playbackState == MprisPlaybackState.Playing
        interval: 100
        repeat: true
        onTriggered: {
            activePlayer.positionChanged();
        }
    }

    
    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutBack
        }
    }

    Behavior on radius {
        NumberAnimation {
            duration: 600
            easing.type: Easing.InOutCubic
        }
    }

    property bool hovered: false

    /* Used for dynamic colors for album art (not fully supported)
    Connections {
        target: activePlayer ? activePlayer : null
        function onPostTrackChanged() {
            console.log("postTrackChanged signal received");
            // updateColors();
            // albumArtImage.source = activePlayer.trackArtUrl;
            // title.text = activePlayer.trackTitle;
            // artist.text = activePlayer.trackArtist;

        }
    }
    */

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onEntered: container.hovered = true
        onExited: container.hovered = false
        z: 2
    }

    Rectangle { // Progress thing
        id: progressBar
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        height: 3
        color: activePlayer.playbackState === MprisPlaybackState.Playing ? Colors.inverse_primary : Colors.primary_container
        width: parent.width * activePlayer.position / activePlayer.length
        radius: 1.5

        Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
        }
        Behavior on width {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    }

    RowLayout {
        id: content
        spacing: 5
        anchors.fill: parent

        ClippingWrapperRectangle {
            id: albumart
            color: "transparent"
            Layout.fillHeight: true
            property int margins: 3
            Layout.topMargin: margins
            Layout.bottomMargin: margins
            Layout.leftMargin: margins
            // make width smaller if there's no album art
            implicitWidth: activePlayer.trackArtUrl ? height : 5
            Layout.alignment: Qt.AlignVCenter
            radius: 99

            Behavior on radius {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            Image {
                id: albumArtImage
                anchors.fill: parent
                visible: !!activePlayer.trackArtUrl
                source: activePlayer.trackArtUrl
                fillMode: Image.PreserveAspectCrop

                states: [
                    State {
                        name: "playing"
                        when: activePlayer.playbackState === MprisPlaybackState.Playing
                        PropertyChanges {
                            target: albumArtImage
                            rotation: 360
                        }
                    },
                    State {
                        name: "paused"
                        when: activePlayer.playbackState !== MprisPlaybackState.Playing
                        PropertyChanges {
                            target: albumArtImage
                            rotation: 0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "*"
                        to: "playing"
                        RotationAnimator {
                            from: 0
                            to: 360
                            duration: 16000
                            loops: Animation.Infinite
                            easing.type: Easing.Linear
                        }
                    },
                    Transition {
                        from: "playing"
                        to: "paused"
                        NumberAnimation {
                            properties: "rotation"
                            duration: 400
                            easing.type: Easing.InOutQuad
                        }
                    }
                ]
            }
        }
        ColumnLayout {
            id: info
            spacing: 2
            Text {
                id: title
                text: activePlayer.trackTitle ? activePlayer.trackTitle : "Unknown Title"
                font.pixelSize: artist.visible ? 14 : 15
                font.bold: true
                font.family: Config.fontFamily
                color: Colors.on_primary_container
            }
            Text {
                visible: !!activePlayer.trackArtist
                id: artist
                text: activePlayer.trackArtist
                font.pixelSize: 9
                font.family: Config.fontFamily
                color: Colors.on_primary_container
            }
        }

        // Buttons
        RowLayout {
            id: buttonWrapper
            spacing: 2
            Layout.rightMargin: 5
            Layout.leftMargin: 5
            Layout.alignment: Qt.AlignVCenter

            Text {
                id: prevButton
                text: "skip_previous"
                renderType: Text.NativeRendering
                font.pixelSize: 20
                color: Colors.on_primary_container
                width: hovered ? implicitWidth : 0
                opacity: hovered ? 1 : 0
                property bool pressed: false
                scale: pressed ? 0.85 : 1.0
                font.family: "Material Symbols Rounded"
                font.variableAxes: { "FILL": 0 }
                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPressed: parent.pressed = true
                    onReleased: parent.pressed = false
                    onClicked: activePlayer.previous()
                }
            }

            Text {
                id: playPauseButton
                font.family: "Material Symbols Rounded"
                font.variableAxes: { "FILL": 1 }
                renderType: Text.NativeRendering
                text: activePlayer.playbackState === MprisPlaybackState.Playing ? "pause" : "play_arrow"
                font.pixelSize: 25
                color: Colors.on_primary_container
                width: hovered ? implicitWidth : 0
                opacity: hovered ? 1 : 0
                property bool pressed: false
                scale: pressed ? 0.85 : 1.0

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPressed: parent.pressed = true
                    onReleased: parent.pressed = false
                    onClicked: activePlayer.togglePlaying()
                }
            }

            Text {
                id: nextButton
                text: "skip_next"
                font.pixelSize: 20
                font.family: "Material Symbols Rounded"
                font.variableAxes: { "FILL": 0 }
                renderType: Text.NativeRendering
                color: Colors.on_primary_container
                width: hovered ? implicitWidth : 0
                opacity: hovered ? 1 : 0
                property bool pressed: false
                scale: pressed ? 0.85 : 1.0

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPressed: parent.pressed = true
                    onReleased: parent.pressed = false
                    onClicked: activePlayer.next()
                }
            }
        }
    }
}
