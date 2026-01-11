import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.bar.contents
import qs.modules.common

Rectangle {
    radius: 999
    color: GlobalVars.sidebarVisible ? Colors.surface_bright : Colors.surface_container
    implicitWidth: content.implicitWidth

    Behavior on width {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutBounce
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            GlobalVars.sidebarVisible = !GlobalVars.sidebarVisible
        }
    }

    RowLayout {
        id: content
        anchors.fill: parent
        spacing: 0

        Loader {
            sourceComponent: Network {}
            Layout.fillHeight: true
            Layout.leftMargin: 2
            Layout.rightMargin: 2
            Layout.topMargin: 2
            Layout.bottomMargin: 2
        }

        Loader {
            sourceComponent: Bluetooth {}
            Layout.fillHeight: true
            Layout.leftMargin: 2
            Layout.rightMargin: 2
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            visible: this.item.adapterState === "connected" || Config.btShowOnEmpty
        }

        /* Loader {
            sourceComponent: Privacy {}
            Layout.fillHeight: true
            Layout.leftMargin: 2
            Layout.rightMargin: 2
            Layout.topMargin: 2
            Layout.bottomMargin: 2
        } */
    }
}