pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Hematite.Blobs
import qs.modules.bar.contents
import qs.services

Item {
    id: root
    required property BlobGroup blobGroup

    anchors.fill: parent

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 10

        // Left side

        Workspaces {
            Layout.fillHeight: true
            Layout.margins: 4
            blobGroup: root.blobGroup
        }

        Media {
            Layout.fillHeight: true
            Layout.margins: 4
            blobGroup: root.blobGroup
        }

        Item {
            Layout.fillWidth: true
        }

        // Right side
        // ...

        SysTray {
            Layout.fillHeight: true
            Layout.margins: 4
        }

        System {
            Layout.fillHeight: true
            Layout.margins: 4
        }
    }

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 5
        }
        spacing: 10

        Launcher {
            Layout.fillHeight: true
            Layout.margins: 4
        }

        Clock {
            Layout.fillHeight: true
            Layout.margins: 4
        }
    }
}
