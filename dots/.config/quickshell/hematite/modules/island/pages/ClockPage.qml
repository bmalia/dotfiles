pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common

Item {
    id: root

    property string pageId: "clock"
    property string title: "Clock"
    property string materialIcon: "schedule"
    property int priority: 20
    property bool hasCollapsedContent: true
    property bool isActive: true
    property int collapsedWidth: 0
    property int sidePillWidth: 0

    property Component collapsedComponent: Component {
        Item {
            implicitWidth: content.implicitWidth + 80
            implicitHeight: content.implicitHeight

            RowLayout {
                id: content
                spacing: 8
                anchors.fill: parent

                Text {
                    text: Config.options.use24hrClock ? Qt.formatTime(clock.date, "HH:mm") : Qt.formatTime(clock.date, "hh:mm AP")
                    color: Appearance.colors.on_surface
                    font.family: Config.options.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    property Component sidePillComponent: Component {
        Item {
            implicitWidth: content.implicitWidth + 20
            implicitHeight: content.implicitHeight

            RowLayout {
                id: content
                anchors.centerIn: parent
                spacing: 6

                Text {
                    text: Config.options.use24hrClock ? Qt.formatTime(clock.date, "HH:mm") : Qt.formatTime(clock.date, "hh:mm AP")
                    color: Appearance.colors.on_surface
                    font.family: Config.options.fontFamily
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }
    }

    property Component expandedComponent: Component {
        Item {

            Column {
                anchors.centerIn: parent
                spacing: 4

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Config.options.use24hrClock ? Qt.formatTime(clock.date, "HH:mm") : Qt.formatTime(clock.date, "hh:mm AP")
                    color: Appearance.colors.on_surface
                    font.family: Config.options.fontFamily
                    font.pixelSize: 44
                    font.bold: true
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDateTime(clock.date, "dddd, MMMM d")
                    color: Qt.alpha(Appearance.colors.on_surface, 0.75)
                    font.family: Config.options.fontFamily
                    font.pixelSize: 16
                }
            }
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}