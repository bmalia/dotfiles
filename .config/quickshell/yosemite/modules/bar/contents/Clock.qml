import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets.shapes
import "../../widgets/shapes/material-shapes.js" as MaterialShapes

Rectangle {
    id: root
    implicitWidth: content.implicitWidth + 10
    radius: 15
    color: Appearance.colors.surface

    RowLayout {
        id: content
        spacing: 5
        Item {
            id: analogClock
            height: 40
            width: 40
            ShapeCanvas {
                anchors.centerIn: parent
                implicitHeight: 28
                implicitWidth: 28
                roundedPolygon: MaterialShapes.getCookie12Sided()
                color: Appearance.colors.primary
                Rectangle {
                    anchors.centerIn: parent
                    width: 4
                    height: 4
                    color: Appearance.colors.on_primary
                    radius: 2
                }
                // Clock hands
                Rectangle {
                    width: 3
                    anchors.bottom: parent.verticalCenter
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 4
                    color: Appearance.colors.on_primary
                    radius: 10
                    rotation: clock.date.getHours() * 30 + clock.date.getMinutes() * 0.5
                    transformOrigin: Item.Bottom
                }
                Rectangle {
                    width: 2
                    anchors.bottom: parent.verticalCenter
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 2
                    color: Appearance.colors.on_primary
                    radius: 10
                    rotation: clock.date.getMinutes() * 6
                    transformOrigin: Item.Bottom
                }
            }
        }

        Text {
            id: timeText
            text: Config.options.use24hrClock ? Qt.formatTime(clock.date, "HH:mm") : Qt.formatTime(clock.date, "hh:mm AP")
            color: Appearance.colors.on_surface
            font.pixelSize: 16
            font.family: Config.options.fontFamily
            font.bold: true
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            id: dateText
            width: visible ? implicitWidth : 0
            text: Qt.formatDateTime(clock.date, "- ddd, MMM d")
            font.family: Config.options.fontFamily
            font.pixelSize: 16
            color: Appearance.colors.on_surface
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}