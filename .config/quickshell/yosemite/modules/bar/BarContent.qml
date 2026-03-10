import QtQuick
import Quickshell
import Quickshell.Services.UPower
import QtQuick.Layouts
import qs.modules.bar.contents

Rectangle {
    id: root
    width: 50
    height: 50
    color: "transparent"

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 10

        Loader {
            sourceComponent: CookieButton {}
            Layout.fillHeight: true
            Layout.margins: 5
        }
        
    }
}
