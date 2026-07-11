import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.modules.common
import qs.modules.widgets

Item {
    id: root
    readonly property bool hideInput: !PolkitService.flow?.responseVisible ?? true
    property bool authInProgress: false

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Escape) {
            PolkitService.cancel();
        }
    }

    function submit() {
        PolkitService.submit(inputField.text);
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Appearance.colors.scrim
        opacity: 0

        Component.onCompleted: {
            opacity = 0.5;
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        id: dialog
        anchors.centerIn: parent
        implicitWidth: 450
        implicitHeight: contentLayout.implicitHeight + 40
        color: Appearance.colors.surface
        radius: 20
        opacity: 0

        Component.onCompleted: {
            opacity = 1;
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        ColumnLayout {
            id: contentLayout
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
                margins: 10
                leftMargin: 20
                rightMargin: 20
            }
            spacing: 20

            Rectangle {
                id: headerPill
                width: headerPillContent.implicitWidth + 20
                height: 30
                radius: 99
                color: PolkitService.flow.failed ? Appearance.colors.error_container : Appearance.colors.secondary_container
                Layout.alignment: Qt.AlignHCenter

                RowLayout {
                    id: headerPillContent
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 1
                    spacing: 5

                    MaterialIcon {
                        text: PolkitService.flow.failed ? "error" : "security"
                        iconSize: 18
                        color: PolkitService.flow.failed ? Appearance.colors.on_error_container : Appearance.colors.on_secondary_container
                    }

                    Text {
                        text: PolkitService.flow.failed ? "Failed" : "Security"
                        font.pixelSize: 15
                        font.family: Config.options.fontFamily
                        color: PolkitService.flow.failed ? Appearance.colors.on_error_container : Appearance.colors.on_secondary_container
                    }
                }
            }

            Image {
                visible: PolkitService.flow?.iconName.length > 0
                width: 64
                height: 64
                fillMode: Image.PreserveAspectCrop
                Layout.alignment: Qt.AlignHCenter
                source: Quickshell.iconPath(PolkitService.flow?.iconName)
            }

            Text {
                Layout.fillWidth: true
                text: PolkitService.cleanMessage
                font.pixelSize: 22
                color: Appearance.colors.on_surface
                font.family: Config.options.fontFamily
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                Layout.fillWidth: true
                text: PolkitService.flow.supplementaryMessage
                visible: PolkitService.flow.supplementaryMessage.length > 0
                font.pixelSize: 16
                color: PolkitService.flow.supplementaryisError ? Appearance.colors.error : Appearance.colors.on_surface_variant
                font.family: Config.options.fontFamily
                font.italic: true
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
            }

            WavyLine {
                Layout.fillWidth: true
                height: 20
                lineWidth: 2
                amplitudeMultiplier: 1.6
                frequency: 16
                color: Appearance.colors.outline_variant
            }

            MaterialTextField {
                id: inputField
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                placeholderText: PolkitService.cleanPrompt
                focus: true
                echoMode: root.hideInput ? TextInput.Password : TextInput.Normal
                onAccepted: {
                    root.submit();
                }

                Keys.onPressed: event => { // Esc to close
                    if (event.key === Qt.Key_Escape) {
                        PolkitService.cancel();
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                spacing: 2

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    Layout.horizontalStretchFactor: 3
                    color: Appearance.colors.tertiary_container
                    radius: 99
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            PolkitService.cancel();
                        }
                    }

                    Row {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 1
                        spacing: 5

                        MaterialIcon {
                            text: "close"
                            iconSize: 18
                            color: Appearance.colors.on_tertiary_container
                        }

                        Text {
                            text: "Cancel"
                            font.pixelSize: 15
                            font.family: Config.options.fontFamily
                            font.bold: true
                            color: Appearance.colors.on_tertiary_container
                        }
                    }
                }

                Item {
                    width: 1
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    Layout.horizontalStretchFactor: 4
                    color: Appearance.colors.primary
                    radius: 10
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.submit();
                        }
                    }

                    Row {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 1
                        spacing: 5

                        MaterialIcon {
                            text: "check"
                            iconSize: 18
                            color: Appearance.colors.on_primary
                        }

                        Text {
                            text: "Confirm"
                            font.pixelSize: 15
                            font.family: Config.options.fontFamily
                            font.bold: true
                            color: Appearance.colors.on_primary
                        }
                    }
                }
            }
        }
    }
}
