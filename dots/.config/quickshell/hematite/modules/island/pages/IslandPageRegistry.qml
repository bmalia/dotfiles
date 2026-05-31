pragma ComponentBehavior: Bound

import QtQuick
import "."

Item {
    id: root
    visible: false
    implicitWidth: 0
    implicitHeight: 0

    readonly property var pages: [
        mediaPage,
        privacyPage,
        notificationsPage,
        clockPage,
    ]

    Item {
        id: measurementLayer
        visible: false
        implicitWidth: 0
        implicitHeight: 0

        Loader {
            id: mediaCollapsedMeasure
            active: true
            visible: false
            sourceComponent: mediaPage.collapsedComponent
        }

        Loader {
            id: mediaSideMeasure
            active: true
            visible: false
            sourceComponent: mediaPage.sidePillComponent
        }

        Loader {
            id: privacyCollapsedMeasure
            active: true
            visible: false
            sourceComponent: privacyPage.collapsedComponent
        }

        Loader {
            id: privacySideMeasure
            active: true
            visible: false
            sourceComponent: privacyPage.sidePillComponent
        }

        Loader {
            id: notificationsCollapsedMeasure
            active: true
            visible: false
            sourceComponent: notificationsPage.collapsedComponent
        }

        Loader {
            id: notificationsSideMeasure
            active: true
            visible: false
            sourceComponent: notificationsPage.sidePillComponent
        }

        Loader {
            id: clockCollapsedMeasure
            active: true
            visible: false
            sourceComponent: clockPage.collapsedComponent
        }

        Loader {
            id: clockSideMeasure
            active: true
            visible: false
            sourceComponent: clockPage.sidePillComponent
        }
    }

    MediaPage {
        id: mediaPage
    }

    PrivacyPage {
        id: privacyPage
    }

    NotificationsPage {
        id: notificationsPage
    }

    ClockPage {
        id: clockPage
    }

    Binding {
        target: mediaPage
        property: "collapsedWidth"
        value: mediaCollapsedMeasure.implicitWidth
    }

    Binding {
        target: mediaPage
        property: "sidePillWidth"
        value: mediaSideMeasure.implicitWidth
    }

    Binding {
        target: privacyPage
        property: "collapsedWidth"
        value: privacyCollapsedMeasure.implicitWidth
    }

    Binding {
        target: privacyPage
        property: "sidePillWidth"
        value: privacySideMeasure.implicitWidth
    }

    Binding {
        target: notificationsPage
        property: "collapsedWidth"
        value: notificationsCollapsedMeasure.implicitWidth
    }

    Binding {
        target: notificationsPage
        property: "sidePillWidth"
        value: notificationsSideMeasure.implicitWidth
    }

    Binding {
        target: clockPage
        property: "collapsedWidth"
        value: clockCollapsedMeasure.implicitWidth
    }

    Binding {
        target: clockPage
        property: "sidePillWidth"
        value: clockSideMeasure.implicitWidth
    }
}
