pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.modules.common
import qs.modules.widgets
import qs.services

Item {
    id: root

    property string pageId: "media"
    property string title: "Media"
    property int priority: 10
    property bool hasCollapsedContent: true
    property bool isActive: MprisController.activePlayer !== null
    property MprisPlayer activePlayer: MprisController.activePlayer
    property int collapsedWidth: 0
    property int sidePillWidth: 0

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
                spacing: 5

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
                            color: Appearance.colors.surface_container

                            MaterialIcon {
                                anchors.centerIn: parent
                                text: "music_note"
                                filled: true
                                font.pixelSize: Math.max(12, parent.height * 0.55)
                                color: Appearance.colors.on_surface
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.maximumWidth: 250
                    spacing: 0
                    Text {
                        text: root.activePlayer.trackTitle || "Nothing playing"
                        color: Appearance.colors.on_surface
                        font.family: Config.options.fontFamily
                        font.pixelSize: 14
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.activePlayer.trackArtist
                        visible: root.activePlayer.trackArtist.length > 0
                        color: Qt.alpha(Appearance.colors.on_surface, 0.72)
                        font.family: Config.options.fontFamily
                        font.pixelSize: 9
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }

    property Component sidePillComponent: Component {
        Item {
            id: rootItem
            implicitWidth: content.implicitWidth
            implicitHeight: content.implicitHeight

            Row {
                id: content
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 6

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 18
                    height: 18
                    radius: 9
                    color: Qt.alpha(Appearance.colors.primary, 0.25)

                    Text {
                        anchors.centerIn: parent
                        text: "music_note"
                        color: Appearance.colors.primary
                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 12
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(20, parent.width - 30)
                    text: "Media"
                    color: Appearance.colors.on_surface
                    font.family: Config.options.fontFamily
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideRight
                }
            }
        }
    }

    property Component expandedComponent: Component {
        Item {
            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 8

                Text {
                    text: "Now Playing"
                    color: Qt.alpha(Appearance.colors.on_surface, 0.7)
                    font.family: Config.options.fontFamily
                    font.pixelSize: 12
                    font.capitalization: Font.AllUppercase
                }

                Text {
                    text: MprisController.activeTrack?.title || "Nothing playing"
                    color: Appearance.colors.on_surface
                    font.family: Config.options.fontFamily
                    font.pixelSize: 26
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    text: MprisController.activeTrack?.artist || ""
                    visible: text.length > 0
                    color: Qt.alpha(Appearance.colors.on_surface, 0.72)
                    font.family: Config.options.fontFamily
                    font.pixelSize: 16
                    elide: Text.ElideRight
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
}
