pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    property alias server: notificationServer

    property int numNotifications: notificationServer.trackedNotifications.values.length

    NotificationServer {
        id: notificationServer
        // Support hints
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        persistenceSupported: true
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true

        onNotification: function(notification) {
            notification.tracked = true
            console.log("Notification received: " + notification.appName + " - " + notification.summary)
        }
    }
}