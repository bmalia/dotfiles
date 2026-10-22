pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common

Item {
    id: root
    width: buttonRow.width
    height: buttonRow.height
    property int buttonAmount: 2
    property int selectedIndex: 1
    property list<string> buttonLabels: ["Button 1", "Button 2"]
    property list<string> buttonIcons: ["", ""]

    signal indexChanged(int index)

    

    RowLayout {
        id: buttonRow
        spacing: 2
        Repeater {
            model: root.buttonAmount
            delegate: Rectangle {
                id: buttonContainer
                required property int index
                width: buttonContent.width + 25
                height: 40
                color: index === root.selectedIndex ? Appearance.colors.secondary : Appearance.colors.secondary_container
                topLeftRadius: index === root.selectedIndex ? 999 : index === 0 ? 999 : 5
                bottomLeftRadius: index === root.selectedIndex ? 999 : index === 0 ? 999 : 5
                topRightRadius: index === root.selectedIndex ? 999 : index === root.buttonAmount - 1 ? 999 : 5
                bottomRightRadius: index === root.selectedIndex ? 999 : index === root.buttonAmount - 1 ? 999 : 5

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                RowLayout {
                    id: buttonContent
                    anchors.centerIn: parent
                    anchors.margins: 8
                    MaterialIcon {
                        text: root.buttonIcons[buttonContainer.index]
                        color: buttonContainer.index === root.selectedIndex ? Appearance.colors.on_secondary : Appearance.colors.on_secondary_container
                        iconSize: 20
                        Layout.alignment: Qt.AlignVCenter
                        filled: false

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }

                    Text {
                        text: root.buttonLabels[buttonContainer.index]
                        color: buttonContainer.index === root.selectedIndex ? Appearance.colors.on_secondary : Appearance.colors.on_secondary_container
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                        font.family: Config.options.fontFamily

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.selectedIndex = parent.index;
                        root.indexChanged(root.selectedIndex);
                    }
                }
            }
        }
    }
}
