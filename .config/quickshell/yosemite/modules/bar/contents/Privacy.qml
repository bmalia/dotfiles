import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.modules.common
import qs.services

Rectangle {
    radius: 999
    color: Colors.surface_container
    implicitWidth: content.implicitWidth

    RowLayout {
        anchors.fill: parent
        id: content
        Text {
            id: micIcon
            visible: Privacy.screenSharing
            text: Privacy.screenSharing
            
        }
    }
}