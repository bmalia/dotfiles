import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common
import qs.services
import qs.modules.widgets

Rectangle {
    id: root
    visible: Mpris.players.values.length > 0
    width: parent.width
    height: visible ? 120 : 0
    color: Colors.surface_container_lowest
    radius: 20

    MediaPlayer {
        anchors.fill: parent
        player: MprisController.activePlayer
    }



    /*StackLayout {
        anchors.fill: parent
        currentIndex: 0
        Repeater {
            model: Mpris.players
            delegate: MediaPlayer {
                player: modelData
            }
        }
    }*/
}
