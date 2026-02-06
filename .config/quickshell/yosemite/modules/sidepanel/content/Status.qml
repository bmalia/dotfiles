import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.common

Rectangle {
    id: statusContent
    height: contents.implicitHeight + 10
    Layout.fillWidth: true
    color: "transparent"

    RowLayout {
        id: contents
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Rectangle {
            id: nameContainer
            width: name.paintedWidth + 20
            height: name.paintedHeight + 10
            color: Colors.primary
            radius: 999

            Text {
                id: name
                anchors.centerIn: parent
                property string username
                property string hostname
                font.pixelSize: 13
                color: Colors.on_primary
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                text: username + "@" + hostname

                Process {
                    id: hostnameProcess
                    running: true
                    command: ["hostnamectl", "hostname"]
                    stdout: StdioCollector {
                        onStreamFinished: {
                            name.hostname = this.text.trim();
                        }
                    }
                }
                Process {
                    id: usernameProcess
                    running: true
                    command: ["whoami"]
                    stdout: StdioCollector {
                        onStreamFinished: {
                            name.username = this.text.trim();
                        }
                    }
                }
            }
        }

        Item {
            id: spacer
            Layout.fillWidth: true
        }

        Button {
            id: settingsButton
            Layout.fillHeight: true
            Layout.preferredWidth: height

            contentItem: Text {
                text: "settings"
                renderType: Text.NativeRendering
                font.pixelSize: 20
                color: Colors.on_surface
                font.family: "Material Symbols Rounded"
                font.variableAxes: { "FILL": 0 }

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: settingsButton.down ? Colors.primary_container : Colors.surface_container
                radius: 999
            }

            onClicked: {
                Quickshell.execDetached(["quickshell", "-p", Quickshell.shellPath("Settings.qml")]);
            }
        }

        Button {
            id: powerButton
            Layout.fillHeight: true
            Layout.preferredWidth: height

            contentItem: Text {
                text: "power_settings_new"
                renderType: Text.NativeRendering
                font.pixelSize: 20
                color: Colors.on_surface
                font.family: "Material Symbols Rounded"
                font.variableAxes: { "FILL": 0 }

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: powerButton.down ? Colors.primary_container : Colors.surface_container
                radius: 999
            }

            onClicked: {
                Quickshell.execDetached(["wlogout"]);
            }
        }
    }
}
