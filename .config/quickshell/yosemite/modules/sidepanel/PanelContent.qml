import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.modules.sidepanel.content

Item {
    id: panelContent
    anchors.fill: parent

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Loader {
            id: statusLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            sourceComponent: Status {}
        }
    }
        
}