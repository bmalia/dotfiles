pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets
import qs.modules.island.pages as IslandPages

Variants {
    model: Quickshell.screens

    delegate: Component {
        PanelWindow {
            id: root
            required property var modelData

            anchors {
                top: !Config.options.bar.bottom
                bottom: Config.options.bar.bottom
                left: true
                right: true
            }
            screen: modelData
            exclusionMode: ExclusionMode.Ignore
            implicitHeight: 1000
            color: "transparent"

            property bool expanded: false
            property bool targetExpanded: expanded
            property string activePageId: centerPage ? centerPage.pageId : ""
            property string targetActivePageId: activePageId
            property string rememberedExpandedPageId: ""
            property real contentOpacity: 1
            property var previousCenterPageId: null
            readonly property var activePage: root.sortedPages.find(page => page.pageId === root.activePageId) || root.centerPage
            readonly property int activeExpandedWidth: (root.activePage && root.activePage.expandedWidth > 0) ? root.activePage.expandedWidth : Math.max(1000, root.screen.width * 0.46)
            readonly property int activeExpandedHeight: (root.activePage && root.activePage.expandedHeight > 0) ? root.activePage.expandedHeight : Math.max(450, root.screen.height * 0.35)

            readonly property var sortedPages: {
                const pages = pageRegistry.pages.slice();
                pages.sort((a, b) => a.priority - b.priority);
                return pages;
            }

            readonly property var collapsedPages: {
                const pages = [];

                for (const page of root.sortedPages) {
                    if (page.hasCollapsedContent && page.isActive) {
                        pages.push(page);
                    }
                }

                if (pages.length === 0) {
                    const clock = root.sortedPages.find(page => page.pageId === "clock");
                    if (clock) {
                        pages.push(clock);
                    }
                }

                return pages;
            }

            readonly property var centerPage: root.collapsedPages.length > 0 ? root.collapsedPages[0] : null
            readonly property var sidePages: root.collapsedPages.slice(1)

            readonly property int activeIndex: pageIndexForId(activePageId)

            function pageIndexForId(pageId) {
                const index = root.sortedPages.findIndex(page => page.pageId === pageId);
                return index >= 0 ? index : 0;
            }

            onCollapsedPagesChanged: {
                if (!root.centerPage) {
                    root.activePageId = "";
                    root.rememberedExpandedPageId = "";
                    return;
                }

                const hasActive = root.sortedPages.some(page => page.pageId === root.activePageId);
                if (!hasActive) {
                    root.activePageId = root.centerPage.pageId;
                }

                const hasRemembered = root.sortedPages.some(page => page.pageId === root.rememberedExpandedPageId);
                if (!hasRemembered) {
                    root.rememberedExpandedPageId = root.centerPage.pageId;
                }
            }

            onExpandedChanged: {
                root.targetExpanded = root.expanded;

                if (root.expanded) {
                    const hasRemembered = root.sortedPages.some(page => page.pageId === root.rememberedExpandedPageId);
                    root.activePageId = hasRemembered ? root.rememberedExpandedPageId : (root.centerPage ? root.centerPage.pageId : "");
                    root.targetActivePageId = root.activePageId;
                    return;
                }

                const hasActive = root.sortedPages.some(page => page.pageId === root.activePageId);
                if (hasActive) {
                    root.rememberedExpandedPageId = root.activePageId;
                }
            }

            onActivePageIdChanged: {
                if (!root.expanded) {
                    return;
                }

                const hasActive = root.sortedPages.some(page => page.pageId === root.activePageId);
                if (hasActive) {
                    root.rememberedExpandedPageId = root.activePageId;
                }
            }

            onTargetActivePageIdChanged: {
                if (root.expanded) {
                    root.activePageId = root.targetActivePageId;
                    return;
                }

                if (root.targetActivePageId === root.activePageId) {
                    return;
                }

                fadeOutThenIn.restart();
                activePageDelayTimer.restart();
            }

            onCenterPageChanged: {
                if (root.expanded) {
                    return;
                }

                const currentPageId = root.centerPage ? root.centerPage.pageId : null;
                if (root.previousCenterPageId !== currentPageId && root.previousCenterPageId !== null) {
                    fadeOutThenIn.start();
                }
                root.previousCenterPageId = currentPageId;
            }

            onTargetExpandedChanged: {
                if (root.targetExpanded === root.expanded) {
                    return;
                }

                fadeOutThenIn.restart();
                expandDelayTimer.start();
            }

            Timer {
                id: expandDelayTimer
                interval: 200
                repeat: false

                onTriggered: {
                    root.expanded = root.targetExpanded;
                }
            }

            Timer {
                id: activePageDelayTimer
                interval: 250
                repeat: false

                onTriggered: {
                    root.activePageId = root.targetActivePageId;
                }
            }

            SequentialAnimation {
                id: fadeOutThenIn

                NumberAnimation {
                    id: fadeOut
                    target: root
                    property: "contentOpacity"
                    to: 0
                    duration: 250
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.easings.standardDefaultEffects
                }

                PauseAnimation {
                    duration: 300
                }

                NumberAnimation {
                    target: root
                    property: "contentOpacity"
                    to: 1
                    duration: 200
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.easings.standardDefaultEffects
                }
            }

            IslandPages.IslandPageRegistry {
                id: pageRegistry
            }

            mask: Region {
                item: island

                Region {
                    item: sidePillLayer
                }
                
                Region {
                    item: controlsRow
                }
            }

            Rectangle {
                id: controlsRow
                z: 1
                opacity: root.expanded ? 1 : 0
                visible: opacity > 0.001
                color: "transparent"
                anchors {
                    top: parent.top
                    topMargin: root.expanded ? 10 : 15
                    horizontalCenter: parent.horizontalCenter
                }
                implicitWidth: island.implicitWidth / 2
                implicitHeight: 40

                Behavior on anchors.topMargin {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                    }
                }

                RowLayout {
                    z: 3
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 10

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.topMargin: 2
                        Layout.bottomMargin: 2
                        implicitWidth: 50 * controlsRow.opacity
                        radius: 20
                        color: Appearance.colors.error

                        MaterialIcon {
                            anchors.centerIn: parent
                            text: "close"
                            iconSize: 20
                            filled: true
                            color: Appearance.colors.on_error
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.targetExpanded = false;
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        implicitWidth: pageButtonsRow.implicitWidth + 10
                        color: Qt.alpha(Appearance.colors.surface, Appearance.surfaceOpacity1)
                        radius: 15

                        RowLayout {
                            id: pageButtonsRow
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            spacing: 2

                            Repeater {
                                model: root.sortedPages

                                delegate: Rectangle {
                                    id: pageButton
                                    required property var modelData
                                    required property int index

                                    implicitWidth: 50 * controlsRow.opacity
                                    height: 30
                                    radius: pageButton.index === root.activeIndex ? 20 : 10
                                    color: root.activeIndex === pageButton.index ? Appearance.colors.primary : Appearance.colors.surface_container

                                    MaterialIcon {
                                        anchors.centerIn: parent
                                        text: pageButton.modelData.materialIcon || "help_outline"
                                        iconSize: 20
                                        filled: root.activeIndex === pageButton.index
                                        color: root.activeIndex === pageButton.index ? Appearance.colors.on_primary : Appearance.colors.on_surface_variant
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            root.activePageId = pageButton.modelData.pageId;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: island
                z: 2
                anchors {
                    top: parent.top
                    topMargin: root.expanded ? 60 : 8
                    horizontalCenter: parent.horizontalCenter
                }

                Behavior on anchors.topMargin {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                    }
                }

                property real popWidth: 0

                implicitWidth: root.expanded ? root.activeExpandedWidth : (root.centerPage?.collapsedWidth || 0) + popWidth
                implicitHeight: root.expanded ? root.activeExpandedHeight : 48 + popWidth / 4
                color: Qt.alpha(Appearance.colors.background, Appearance.surfaceOpacity1)
                radius: 50

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        if (root.expanded) {
                            root.targetExpanded = false;
                        }
                        return;
                    }
                    onPressed: {
                        island.popWidth = -10;
                    }
                    pressAndHoldInterval: 200

                    onPressAndHold: {
                        root.targetExpanded = !root.targetExpanded;
                        island.popWidth = 0;
                    }

                    onEntered: island.popWidth = 15
                    onExited: island.popWidth = 0
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 450
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                    }
                }

                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                    }
                }

                Loader {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    active: !root.expanded
                    opacity: root.contentOpacity
                    sourceComponent: root.centerPage ? root.centerPage.collapsedComponent : null
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 5
                    visible: root.expanded
                    opacity: root.contentOpacity

                    Text {
                        Layout.alignment: Qt.AlignCenter
                        text: root.sortedPages[root.activeIndex]?.title || ""
                        font.pixelSize: 14
                        font.family: Config.options.fontFamily
                        font.bold: true
                        color: Appearance.colors.on_surface_variant
                    }

                    StackLayout {
                        id: expandedStack
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        currentIndex: root.activeIndex

                        Repeater {
                            model: root.sortedPages

                            delegate: Item {
                                id: expandedPage
                                required property var modelData

                                Loader {
                                    anchors.fill: parent
                                    sourceComponent: expandedPage.modelData.expandedComponent
                                }
                            }
                        }
                    }
                }
            }

            Item {
                id: sidePillLayer
                anchors.horizontalCenter: island.horizontalCenter
                anchors.verticalCenter: island.verticalCenter
                width: (root.sidePages.length > 0) ? island.implicitWidth + root.sidePages.reduce((total, page) => total + page.sidePillWidth + 10, 40) : 0
                height: (root.sidePages.length > 0) ? Math.max(50, island.implicitHeight) : 0

                Repeater {
                    model: root.sortedPages

                    delegate: Rectangle {
                        id: sidePill

                        required property int index
                        required property var modelData

                        readonly property int sideIndex: root.sidePages.findIndex(page => page.pageId === sidePill.modelData.pageId)
                        readonly property bool isSidePage: sideIndex >= 0
                        readonly property int safeIndex: Math.max(0, sideIndex)
                        readonly property bool leftSide: safeIndex % 2 === 0
                        readonly property int lane: Math.floor(safeIndex / 2) + 1

                        readonly property real targetEmerge: (!root.expanded && isSidePage) ? 1 : 0
                        property real emerge: 0
                        property real startDistance: Math.max(8, island.implicitWidth * 0.5 - width * 0.5 - 8)
                        property real endDistance: island.implicitWidth * 0.35 + lane * (width + 23)
                        property real distance: startDistance + (endDistance - startDistance) * emerge

                        y: (parent.height - height) / 2
                        x: parent.width / 2 - width / 2 + (leftSide ? -distance : distance)

                        implicitWidth: sidePill.modelData.sidePillWidth
                        implicitHeight: 40
                        radius: 22
                        color: Qt.alpha(Appearance.colors.background, Appearance.surfaceOpacity1)
                        opacity: emerge
                        scale: 0.2 + 0.8 * emerge
                        visible: sidePill.emerge > 0.001

                        Component.onCompleted: {
                            sidePill.emerge = sidePill.targetEmerge;
                        }

                        onTargetEmergeChanged: {
                            emergeAnimation.stop();
                            emergeAnimation.to = sidePill.targetEmerge;
                            emergeAnimation.start();
                        }

                        NumberAnimation {
                            id: emergeAnimation
                            target: sidePill
                            property: "emerge"
                            duration: (root.expanded ? 500 : 1000) + sidePill.safeIndex * 50
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: root.expanded ? Appearance.easings.expressiveFastSpatial : Appearance.easings.expressiveDefaultSpatial
                        }

                        Loader {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            sourceComponent: sidePill.modelData.sidePillComponent
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: !root.expanded && sidePill.isSidePage
                            acceptedButtons: Qt.LeftButton

                            onClicked: {
                                root.targetExpanded = true;
                                root.ActivePageId = sidePill.modelData.pageId;
                            }
                        }
                    }
                }
            }
        }
    }
}
