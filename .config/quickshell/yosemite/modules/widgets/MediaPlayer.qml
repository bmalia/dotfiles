import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.modules.common

ClippingRectangle {
    width: 200
    radius: 20

    required property MprisPlayer player


    Image {
        id: albumArt
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: player.trackArtUrl
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.4)
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        T
    }
}