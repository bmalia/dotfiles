import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs.modules.bar.contents.media
import qs

Rectangle {
    id: container
    color: Colors.secondary_container
    radius: 999
    implicitWidth: activePlayer ? albumart.width + info.width + 20 + (hovered ? buttonWrapper.width + buttonWrapper.Layout.leftMargin + buttonWrapper.Layout.rightMargin : 0) : 0
    implicitHeight: activePlayer ? 40 : 0
    readonly property MprisPlayer activePlayer: MprisController.activePlayer // Uses the active player determined by MprisController
    visible: !!activePlayer

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutBack
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

    function updateColors() { // Currently not fully supported (unless you want to reload quickshell any time a song changes)
        Quickshell.execDetached(["sh", "-c", "~/.config/quickshell/modules/bar/contents/media/updateColors.sh"]);
        console.log("Colors updated");
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onEntered: container.hovered = true
        onExited: container.hovered = false
        z: 2
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
            radius: width / 2
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
                font.pixelSize: 14
                font.bold: true
                font.family: Config.fontFamily
                color: Colors.on_secondary_container
            }
            Text {
                id: artist
                text: activePlayer.trackArtist ? activePlayer.trackArtist : activePlayer.identity
                font.pixelSize: 9
                font.family: Config.fontFamily
                color: Colors.on_secondary_container
            }
        }

        // Buttons
        RowLayout {
            id: buttonWrapper
            spacing: 15
            Layout.rightMargin: 10
            Layout.leftMargin: 5
            Layout.alignment: Qt.AlignVCenter

            Text {
                id: prevButton
                text: "󰼨"
                font.pixelSize: 20
                color: Colors.on_secondary_container
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
                    onClicked: activePlayer.previous()
                }
            }

            Text {
                id: playPauseButton
                text: activePlayer.playbackState === MprisPlaybackState.Playing ? "󰏤" : "󰼛"
                font.pixelSize: 25
                color: Colors.on_secondary_container
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
                text: "󰼧"
                font.pixelSize: 20
                color: Colors.on_secondary_container
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
