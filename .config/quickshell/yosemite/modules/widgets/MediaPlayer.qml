import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.modules.common

Rectangle {
    id: root
    width: 200
    radius: 20
    color: Qt.darker(albumColors.colors.length > 0 ? albumColors.colors[0] : Colors.surface_container)

    required property MprisPlayer player

    ColorQuantizer {
        id: albumColors
        rescaleSize: 64
        source: root.player.trackArtUrl
        depth: 2
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10

        ClippingWrapperRectangle {
            radius: 20
            Layout.fillHeight: true
            implicitWidth: height
            Image {
                source: root.player.trackArtUrl
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            spacing: 0

            Text {
                text: root.player.trackTitle
                font.bold: true
                font.pointSize: 12
                font.family: Config.fontFamily
                color: albumColors.colors.length > 3 ? albumColors.colors[3] : Colors.on_surface
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
            }

            Text {
                text: root.player.trackArtist
                font.pointSize: 10
                font.family: Config.fontFamily
                color: albumColors.colors.length > 0 ? albumColors.colors[1] : Colors.on_surface
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
            }

            Text {
                text: root.player.trackAlbum
                font.pointSize: 8
                font.family: Config.fontFamily
                color: albumColors.colors.length > 0 ? albumColors.colors[1] : Colors.on_surface
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
            }
        }

        Rectangle {
            Layout.rightMargin: 10
            implicitHeight: 40
            implicitWidth: 40
            radius: root.player.isPlaying ? 10 : 15
            color: albumColors.colors.length > 0 ? albumColors.colors[3] : Colors.primary

            MaterialIcon {
                anchors.centerIn: parent
                text: root.player.isPlaying ? "pause" : "play_arrow"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 28
                filled: true
                color: albumColors.colors.length > 0 ? Qt.darker(albumColors.colors[0]) : Colors.on_primary
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: player.togglePlaying()
            }
        }
    }
}
