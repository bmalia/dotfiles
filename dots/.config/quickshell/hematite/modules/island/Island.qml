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
            implicitHeight: 700
            color: "transparent"

            property bool expanded: false
            property bool targetExpanded: expanded
            property string activePageId: centerPage ? centerPage.pageId : ""
            property string rememberedExpandedPageId: ""
            property real contentOpacity: 1
            property var previousCenterPageId: null

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
                    root.activePageId = hasRemembered
                        ? root.rememberedExpandedPageId
                        : (root.centerPage ? root.centerPage.pageId : "");
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

                fadeOutThenIn.start();
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
                    easing.bezierCurve: Appearance.easings.standardFastEffects
                }
            }

            IslandPages.IslandPageRegistry {
                id: pageRegistry
            }

            mask: Region {
                item: island

                Region {
                    item: leftRound
                }

                Region {
                    item: rightRound
                }

                Region {
                    item: sidePillLayer
                }
            }

            Rectangle {
                id: island
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }

                property real popWidth: 0

                implicitWidth: root.expanded ? root.screen.width / 3 + popWidth : (root.centerPage?.collapsedWidth || 0) + popWidth
                implicitHeight: root.expanded ? root.screen.height / 3 + popWidth : 48 + popWidth
                color: Appearance.colors.background
                bottomLeftRadius: 45
                bottomRightRadius: 45

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: root.targetExpanded = !root.targetExpanded
                    onEntered: island.popWidth = 10
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
                    spacing: 10
                    visible: root.expanded
                    opacity: root.contentOpacity

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: root.sortedPages

                            delegate: Rectangle {
                                id: tabButton
                                required property var modelData

                                radius: 99
                                implicitHeight: 28
                                implicitWidth: tabLabel.implicitWidth + 16
                                color: root.activePageId === tabButton.modelData.pageId ? Qt.alpha(Appearance.colors.on_surface, 0.14) : "transparent"

                                Text {
                                    id: tabLabel
                                    anchors.centerIn: parent
                                    text: tabButton.modelData.title
                                    color: Appearance.colors.on_surface
                                    font.family: Config.options.fontFamily
                                    font.pixelSize: 12
                                    font.bold: root.activePageId === tabButton.modelData.pageId
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.activePageId = tabButton.modelData.pageId
                                }
                            }
                        }
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
                width: (root.sidePages.length > 0)
                    ? island.implicitWidth + root.sidePages.reduce((total, page) => total + page.sidePillWidth + 10, 40)
                    : 0
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
                        property real endDistance: island.implicitWidth * 0.4 + lane * (width + 5)
                        property real distance: startDistance + (endDistance - startDistance) * emerge

                        y: (parent.height - height) / 2
                        x: parent.width / 2 - width / 2 + (leftSide ? -distance : distance)

                        implicitWidth: sidePill.modelData.sidePillWidth
                        implicitHeight: 40
                        radius: 22
                        color: Appearance.colors.background
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
                            duration: (root.expanded ? 200 : 1000) + sidePill.safeIndex * 50
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: root.expanded
                                ? Appearance.easings.expressiveFastSpatial
                                : Appearance.easings.expressiveDefaultSpatial
                        }

                        Loader {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            sourceComponent: sidePill.modelData.sidePillComponent
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: sidePill.isSidePage
                            onClicked: {
                                root.activePageId = sidePill.modelData.pageId;
                                root.expanded = true;
                            }
                        }
                    }
                }
            }

            RoundCorner {
                id: leftRound
                anchors {
                    top: parent.top
                    right: island.left
                }
                corner: RoundCorner.CornerEnum.TopRight
                implicitSize: Math.min(island.implicitHeight * 0.5, 40)
                color: Appearance.colors.background
            }

            RoundCorner {
                id: rightRound
                anchors {
                    top: parent.top
                    left: island.right
                }
                corner: RoundCorner.CornerEnum.TopLeft
                implicitSize: Math.min(island.implicitHeight * 0.5, 40)
                color: Appearance.colors.background
            }
        }
    }
}
