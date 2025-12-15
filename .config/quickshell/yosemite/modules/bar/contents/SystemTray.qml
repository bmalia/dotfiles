import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Rectangle {
    id: container
    property var bar
    implicitWidth: trayIcons.implicitWidth + 20
    implicitHeight: 40
    color: Colors.surface
    radius: 999

    RowLayout {
        id: trayIcons
        anchors.fill: parent
        anchors.margins: 5
        spacing: 0

        Repeater {
            model: SystemTray.items // Use implicitWidth, not width

            delegate: Item {
                width: 20
                height: 20

                IconImage {
                    anchors.centerIn: parent
                    width: 17
                    height: 17
                    source: modelData.icon                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        modelData.display(container.bar, 1700, 40)
                    }
                    // right-click to activate item
                    onPressed: {
                        if (mouse.button === Qt.RightButton) {
                            modelData.activate()
                        }
                    }
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}