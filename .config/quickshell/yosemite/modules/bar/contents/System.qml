import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.bar.contents
import qs.modules.common

Rectangle {
    radius: 999
    color: GlobalVars.sidebarVisible ? Colors.surface_container_highest : Colors.surface_container
    implicitWidth: content.implicitWidth

    Behavior on width {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutBack
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            GlobalVars.sidebarVisible = !GlobalVars.sidebarVisible;
        }
    }

    RowLayout {
        id: content
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        spacing: 0

        Behavior on width {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutBack
            }
        }

        Loader {
            sourceComponent: Network {}
            Layout.fillHeight: true
            Layout.leftMargin: 2
            Layout.rightMargin: 2
            Layout.topMargin: 2
            Layout.bottomMargin: 2
        }

        Loader {
            sourceComponent: IdleStatus {}
            Layout.fillHeight: true
            Layout.leftMargin: 0
            Layout.rightMargin: 0
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
    }
}
