import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs

Rectangle {
    id: container
    color: Colors.surface_container
    radius: 999
    Layout.fillHeight: true
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: clockText.width + 20   // 12px padding on each side
    implicitHeight: clockText.height + 20 // 6px padding top/bottom

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        textFormat: Text.RichText
        text: {
            // 24hr clock config
            let parts = Config.use24hrClock ? Qt.formatDateTime(clock.date, "HH:mm - ddd, MMM d").split("-") : Qt.formatDateTime(clock.date, "h:mm AP -  ddd, MMM d").split("-");
            let time = parts[0];
            let date = parts[1];
            "<span> <b>" + time + "</b> </span> <span style='color:" + ";'> -" + date + "</span>";
        }
        font.family: Config.fontFamily
        font.pixelSize: 17
        color: Colors.on_surface
    }
}
