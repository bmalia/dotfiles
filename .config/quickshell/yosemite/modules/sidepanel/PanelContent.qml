import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.modules.sidepanel.content

Item {
    id: panelContent
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        id: contentLayout
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        anchors.margins: 10
        spacing: 10

        Loader {
            id: statusLoader
            Layout.fillWidth: true
            sourceComponent: Status {}
        }

        Loader {
            id: quickSettingsLoader
            Layout.fillWidth: true
            sourceComponent: QuickSettings {}
        }

        Loader {
            id: wifiBluetoothLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: TabPanel {}
        }
    }
}
